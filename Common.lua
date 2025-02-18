--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- Variables and misceallenous functions ---------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables and constants
--------------------------------------------------------------------------------

BadProfession = false        -- True if the player doesn't have the right profession (Blacksmithing)
FRAMES_WIDTH = 520           -- Width of the frames
FRAMES_HEIGHT = 300          -- Height of the frames
HAMMER_ID = 225660           -- ID of the Earthen Master's Hammer
_, L = ...                   -- Localization
TICKER = 0.1                 -- Ticker duration in seconds

local BLACKSMITHING_ID = 164 -- ID of the Blacksmithing profession

SETTINGS = {
    {
        settingText = L["head_node"],
        settingKey = "head",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["head_node"]),
    },
    {
        settingText = L["shoulder_node"],
        settingKey = "shoulder",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["shoulder_node"]),
    },
    {
        settingText = L["chest_node"],
        settingKey = "chest",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["chest_node"]),
    },
    {
        settingText = L["waist_node"],
        settingKey = "waist",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["waist_node"]),
    },
    {
        settingText = L["legs_node"],
        settingKey = "legs",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["legs_node"]),
    },
    {
        settingText = L["feet_node"],
        settingKey = "feet",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["feet_node"]),
    },
    {
        settingText = L["wrists_node"],
        settingKey = "wrists",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["wrists_node"]),
    },
    {
        settingText = L["hands_node"],
        settingKey = "hands",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["hands_node"]),
    },
    {
        settingText = L["mainHandSettings"],
        settingKey = "mainHand",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["mainHand_node"]),
    },
    {
        settingText = L["offHandSettings"],
        settingKey = "offHand",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["offHand_node"]),
    },
}

ID_TO_NAME = {
    [1] = "head",
    [3] = "shoulder",
    [5] = "chest",
    [6] = "waist",
    [7] = "legs",
    [8] = "feet",
    [9] = "wrists",
    [10] = "hands",
    [16] = "mainHand",
    [17] = "offHand",
}

NAME_TO_ID = {
    head = 1,
    shoulder = 3,
    chest = 5,
    waist = 6,
    legs = 7,
    feet = 8,
    wrists = 9,
    hands = 10,
    mainHand = 16,
    offHand = 17,
    ranged = 18,
}

--------------------------------------------------------------------------------
--- Miscellaneous functions
--------------------------------------------------------------------------------

--- Profession functions

--- Get the name of the profession at the given index
local function getProfessionId(professionIndex)
    if professionIndex then
        local _, _, _, _, _, _, skillId, _, _, _ =
            GetProfessionInfo(professionIndex)
        return skillId
    end
    return "None"
end

-- Check if the player has the right profession: Blacksmithing
function CheckProfession()
    local prof1, prof2, _, _, _ = GetProfessions()

    local skill1 = getProfessionId(prof1)
    local skill2 = getProfessionId(prof2)

    if skill1 ~= BLACKSMITHING_ID and skill2 ~= BLACKSMITHING_ID then -- vérifier blacksmithing
        BadProfession = true
        return
    end

    BadProfession = false
end

--- Frame position functions

-- Save the given frame position in the database
function SaveFramePosition(frame)
    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
    EMHDB.framePos = {
        point = point,
        relativeTo = relativeTo and relativeTo:GetName() or "UIParent",
        relativePoint = relativePoint,
        xOfs = xOfs,
        yOfs = yOfs
    }
end

-- Set the given frame position from the database (or center it if no position is saved)
function SetFramePosition(frame)
    if EMHDB and EMHDB.framePos then
        frame:ClearAllPoints()
        frame:SetPoint(EMHDB.framePos.point, EMHDB.framePos.relativeTo, EMHDB.framePos.relativePoint, EMHDB.framePos
            .xOfs, EMHDB.framePos.yOfs)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

--- EMHDB.keys functions

--[[
Remove an item from EMHDB.keys by its name.
]]
function RemoveByName(name)
    print("Trying to remove name '" .. name .. "' from EMHDB.keys.")
    local id = NAME_TO_ID[name]
    print(name, id)
    if not id then
        print("Aucune ligne trouvée avec name '" .. name .. "' dans NAME_TO_ID.")
        return
    end

    for i = #EMHDB.keys, 1, -1 do
        if EMHDB.keys[i] == id then
            table.remove(EMHDB.keys, i)
            print("Ligne avec name '" .. name .. "' a été enlevée de EMHDB.keys.")
            return
        end
    end
    print("Aucune ligne trouvée avec id '" .. id .. "' dans EMHDB.keys.")
end

--[[
Add an item to EMHDB.keys by its name.
]]
function AddByName(name)
    local id = NAME_TO_ID[name]
    if not id then
        print("Aucune ligne trouvée avec name '" .. name .. "' dans NAME_TO_ID.")
        return
    end

    for _, v in ipairs(EMHDB.keys) do
        if v == id then
            print("Ligne avec name '" .. name .. "' existe déjà dans EMHDB.keys.")
            return
        end
    end

    table.insert(EMHDB.keys, id)
    print("Ligne avec id '" .. id .. "' et name '" .. name .. "' a été ajoutée à EMHDB.keys.")
end
