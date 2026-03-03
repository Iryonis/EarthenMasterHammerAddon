--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------- Capabilities: talent scanning and repair capability logic ------------
--------------------------------------------------------------------------------
-- Scans profession talent trees at login (and on talent changes) to build
-- a capability table. The rest of the addon only does lookups against this
-- table at runtime — no talent tree access during gameplay.
--------------------------------------------------------------------------------

local _, addonTable              = ...

--------------------------------------------------------------------------------
--- Constants
--------------------------------------------------------------------------------

local BLACKSMITHING_ID           = 164

-- Hammer item IDs (highest tier only; lower tiers may be added later)
addonTable.HAMMER_ID_TWW         = 225660
addonTable.HAMMER_ID_MIDNIGHT    = 238020

-- Skill line IDs per expansion
local SKILLLINE_TWW              = 2872
local SKILLLINE_MIDNIGHT         = 2907

-- Spell IDs: learned when the player knows the expansion's profession
local SPELL_ID_TWW               = 423332
local SPELL_ID_MIDNIGHT          = 471004

-- Maximum expansion ID that the TWW hammer can repair
local TWW_MAX_EXPANSION          = 10

-- All repairable equipment slot IDs
addonTable.ALL_REPAIR_SLOTS      = { 1, 3, 5, 6, 7, 8, 9, 10, 16, 17 }

-- Slot ID to localization key (used for display)
addonTable.ID_TO_NAME            = {
    [1]  = "CAP_head",
    [3]  = "CAP_shoulder",
    [5]  = "CAP_chest",
    [6]  = "CAP_waist",
    [7]  = "CAP_legs",
    [8]  = "CAP_feet",
    [9]  = "CAP_wrists",
    [10] = "CAP_hands",
}

-- Ordered list of armor slot IDs for display (mirrors ALL_REPAIR_SLOTS minus weapons)
addonTable.ARMOR_SLOTS_ORDER     = { 1, 3, 5, 6, 7, 8, 9, 10 }

-- Ordered list of weapon category keys for display
addonTable.WEAPON_CATS_ORDER     = { "short_blades", "long_blades", "axes_and_polearms", "maces", "shields" }

-- Weapon category key to localization key
addonTable.CATEGORY_TO_NAME      = {
    short_blades      = "CAP_short_blades",
    long_blades       = "CAP_long_blades",
    axes_and_polearms = "CAP_axes_and_polearms",
    maces             = "CAP_maces",
    shields           = "CAP_shields",
}

-- Weapon subType (from GetItemInfo) mapped to an internal category key
local WEAPON_SUBTYPE_TO_CATEGORY = {
    ["Daggers"]           = "short_blades",
    ["Fist Weapons"]      = "short_blades",
    ["One-Handed Swords"] = "long_blades",
    ["Two-Handed Swords"] = "long_blades",
    ["Warglaives"]        = "long_blades",
    ["One-Handed Axes"]   = "axes_and_polearms",
    ["Two-Handed Axes"]   = "axes_and_polearms",
    ["Polearms"]          = "maces",
    ["One-Handed Maces"]  = "maces",
    ["Two-Handed Maces"]  = "maces",
    ["Shields"]           = "shields",
}

--------------------------------------------------------------------------------
--- Hardcoded node / path IDs for repair talent detection
---
--- These tables map equipment slots (or weapon categories) to the specific
--- node/path IDs in the profession talent trees that unlock repair capability.
---
--- Midnight nodes : checked via C_Traits API  (activeRank == maxRanks)
--- TWW nodes      : checked via C_ProfSpecs API (state == 2 = fully unlocked)
--------------------------------------------------------------------------------

-- Midnight repair nodes
-- Keys  : slot IDs (number) for armor, category strings for weapons
-- Values: C_Traits node IDs
local REPAIR_NODES_MIDNIGHT      = {
    -- Armor
    [1]                   = 104570, -- Head
    [3]                   = 104569, -- Shoulder
    [5]                   = 104574, -- Chest
    [6]                   = 104566, -- Waist
    [7]                   = 104573, -- Legs
    [8]                   = 104568, -- Feet
    [9]                   = 104565, -- Wrist
    [10]                  = 104564, -- Hands
    -- Weapons
    ["short_blades"]      = 104631,
    ["long_blades"]       = 104630,
    ["axes_and_polearms"] = 104627,
    ["maces"]             = 104628,
    ["shields"]           = 104572,
}

-- TWW repair nodes
-- Keys  : same as above
-- Values: C_ProfSpecs path IDs
local REPAIR_NODES_TWW           = {
    -- Armor
    [1]                   = 99233, -- Head
    [3]                   = 99232, -- Shoulder
    [5]                   = 99237, -- Chest
    [6]                   = 99229, -- Waist
    [7]                   = 99236, -- Legs
    [8]                   = 99231, -- Feet
    [9]                   = 99228, -- Wrist
    [10]                  = 99227, -- Hands
    -- Weapons
    ["short_blades"]      = 99451,
    ["long_blades"]       = 99450,
    ["axes_and_polearms"] = 99447,
    ["maces"]             = 99448,
    ["shields"]           = 99235,
}

--------------------------------------------------------------------------------
--- Internal state
--------------------------------------------------------------------------------

-- Capability tables populated by scanning talents
-- Format: { [slotID_or_category] = { source = "midnight" | "tww" } }
local armorCapabilities          = {}
local weaponCapabilities         = {}

--------------------------------------------------------------------------------
--- Hammer detection
--------------------------------------------------------------------------------

-- Check if a specific hammer is present in the player's bags
-- @param hammerID  number  Item ID of the hammer to find
-- @return boolean
local function hasHammerInBags(hammerID)
    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                local currentItemID = tonumber(string.match(itemLink, "item:(%d+)"))
                if currentItemID == hammerID then
                    return true
                end
            end
        end
    end
    return false
end

--------------------------------------------------------------------------------
--- Weapon type detection
--------------------------------------------------------------------------------

-- Get the repair category of the weapon equipped in the given slot
-- @param slotID  number  Equipment slot (16 = main hand, 17 = off hand)
-- @return string|nil  Category key (e.g. "short_blades") or nil
local function getWeaponCategory(slotID)
    local link = GetInventoryItemLink("player", slotID)
    if not link then return nil end
    local _, _, _, _, _, _, itemSubType = C_Item.GetItemInfo(link)
    if not itemSubType then return nil end
    return WEAPON_SUBTYPE_TO_CATEGORY[itemSubType]
end

addonTable.getWeaponCategory = getWeaponCategory

--------------------------------------------------------------------------------
--- Talent scanning
--------------------------------------------------------------------------------

-- Scan Midnight profession talent tree for repair capabilities
-- Uses C_Traits API: a node is unlocked when activeRank >= 1
local function scanMidnightCapabilities()
    if not C_SpellBook.IsSpellInSpellBook(SPELL_ID_MIDNIGHT) then return end

    local configID = C_ProfSpecs.GetConfigIDForSkillLine(SKILLLINE_MIDNIGHT)
    if not configID or configID == 0 then return end

    for key, nodeID in pairs(REPAIR_NODES_MIDNIGHT) do
        local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
        if nodeInfo and nodeInfo.activeRank and nodeInfo.activeRank == nodeInfo.maxRanks then
            if type(key) == "number" then
                armorCapabilities[key] = { source = "midnight" }
            else
                weaponCapabilities[key] = { source = "midnight" }
            end
        end
    end
end

-- Scan TWW profession specialization tree for repair capabilities
-- Uses C_ProfSpecs API: a path is fully unlocked when state == 2
-- Only adds capabilities not already covered by Midnight (Midnight is superset)
local function scanTWWCapabilities()
    if not C_SpellBook.IsSpellInSpellBook(SPELL_ID_TWW) then return end

    local configID = C_ProfSpecs.GetConfigIDForSkillLine(SKILLLINE_TWW)
    if not configID or configID == 0 then return end

    for key, pathID in pairs(REPAIR_NODES_TWW) do
        local existing = (type(key) == "number") and armorCapabilities[key] or weaponCapabilities[key]
        if not existing then
            local state = C_ProfSpecs.GetStateForPath(pathID, configID)
            if state == 2 then
                if type(key) == "number" then
                    armorCapabilities[key] = { source = "tww" }
                else
                    weaponCapabilities[key] = { source = "tww" }
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
--- Profession check
--------------------------------------------------------------------------------

-- Check if the player has Blacksmithing as one of their two professions
local function hasBlacksmithing()
    local profession1, profession2 = GetProfessions()
    if profession1 then
        local _, _, _, _, _, _, skillId = GetProfessionInfo(profession1)
        if skillId == BLACKSMITHING_ID then return true end
    end
    if profession2 then
        local _, _, _, _, _, _, skillId = GetProfessionInfo(profession2)
        if skillId == BLACKSMITHING_ID then return true end
    end
    return false
end

--------------------------------------------------------------------------------
--- Public API
--------------------------------------------------------------------------------

--- Load capabilities from cache if available, otherwise run a full scan.
--- Call at login. Blacksmithing is always checked fresh (fast, not cached).
function EMH_LoadCapabilities()
    addonTable.addonDisabled = true
    addonTable.disableReason = nil

    if not hasBlacksmithing() then
        addonTable.disableReason = "no_blacksmithing"
        EMHDB.capabilitiesCache  = nil
        return
    end

    -- Use cached talent scan results when available
    if EMHDB.capabilitiesCache then
        armorCapabilities  = EMHDB.capabilitiesCache.armor or {}
        weaponCapabilities = EMHDB.capabilitiesCache.weapons or {}

        local hasAny       = false
        for _ in pairs(armorCapabilities) do
            hasAny = true; break
        end
        if not hasAny then
            for _ in pairs(weaponCapabilities) do
                hasAny = true; break
            end
        end

        if hasAny then
            addonTable.addonDisabled = false
            return
        end
        -- Cache is present but empty: fall through to full scan
    end

    -- No valid cache: perform a full talent scan (also saves the result to cache)
    EMH_ScanCapabilities()
end

--- Perform a full talent scan and rebuild the capability tables.
--- Saves results to EMHDB.capabilitiesCache.
--- Call when profession talents change (TRAIT_CONFIG_UPDATED).
function EMH_ScanCapabilities()
    armorCapabilities        = {}
    weaponCapabilities       = {}
    addonTable.addonDisabled = true
    addonTable.disableReason = nil

    if not hasBlacksmithing() then
        addonTable.disableReason = "no_blacksmithing"
        EMHDB.capabilitiesCache  = nil
        return
    end

    -- Scan talents: Midnight first (superset), then TWW fallback
    scanMidnightCapabilities()
    scanTWWCapabilities()

    -- Check if at least one capability was found
    local hasAny = false
    for _ in pairs(armorCapabilities) do
        hasAny = true; break
    end
    if not hasAny then
        for _ in pairs(weaponCapabilities) do
            hasAny = true; break
        end
    end

    if not hasAny then
        addonTable.disableReason = "no_repair_nodes"
        EMHDB.capabilitiesCache  = nil
        return
    end

    -- Persist scan results across sessions
    EMHDB.capabilitiesCache  = { armor = armorCapabilities, weapons = weaponCapabilities }
    addonTable.addonDisabled = false
end

--- Check if a specific equipment slot can be repaired right now.
--- Verifies: capability + hammer in bags + item expansion compatibility.
--- @param slotID  number  Equipment slot ID
--- @return boolean canRepair, number|nil hammerID
function EMH_CanRepairSlot(slotID)
    local cap

    if slotID == 16 or slotID == 17 then
        local category = getWeaponCategory(slotID)
        if not category then return false, nil end
        cap = weaponCapabilities[category]
    else
        cap = armorCapabilities[slotID]
    end

    if not cap then return false, nil end

    -- Determine hammer based on capability source
    local hammerID
    if cap.source == "midnight" then
        hammerID = addonTable.HAMMER_ID_MIDNIGHT
    else
        hammerID = addonTable.HAMMER_ID_TWW
    end

    -- Check hammer is in bags
    if not hasHammerInBags(hammerID) then return false, nil end

    -- TWW hammer cannot repair items from expansions beyond TWW
    if cap.source == "tww" then
        local itemID = GetInventoryItemID("player", slotID)
        if itemID then
            local _, _, _, _, _, _, _, _, _, _, _, _, _, _, expansionID = C_Item.GetItemInfo(itemID)
            if expansionID and expansionID > TWW_MAX_EXPANSION then
                return false, nil
            end
        end
    end

    return true, hammerID
end

--- Get the current capability tables (for display purposes).
--- @return table armorCapabilities, table weaponCapabilities
function EMH_GetCapabilities()
    return armorCapabilities, weaponCapabilities
end

--- Public wrapper for hasHammerInBags, used by display code.
--- @param hammerID  number  Item ID to look for
--- @return boolean
function EMH_HasHammerInBags(hammerID)
    return hasHammerInBags(hammerID)
end
