--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- Variables and misceallenous functions ---------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables and constants
--------------------------------------------------------------------------------

BadProfession = false -- True if the player doesn't have the right profession (Blacksmithing)
HAMMER_ID = 225660    -- ID of the Earthen Master's Hammer
_, L = ...;           -- Localization
TICKER = 0.1          -- Ticker duration in seconds

SETTINGS = {
    {
        settingText = L["head"],
        settingKey = "head",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["head_node"]),
    },
    {
        settingText = L["shoulder"],
        settingKey = "shoulder",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["shoulder_node"]),
    },
    {
        settingText = L["chest"],
        settingKey = "chest",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["chest_node"]),
    },
    {
        settingText = L["waist"],
        settingKey = "waist",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["waist_node"]),
    },
    {
        settingText = L["legs"],
        settingKey = "legs",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["legs_node"]),
    },
    {
        settingText = L["feet"],
        settingKey = "feet",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["feet_node"]),
    },
    {
        settingText = L["wrists"],
        settingKey = "wrists",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["wrists_node"]),
    },
    {
        settingText = L["hands"],
        settingKey = "hands",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["hands_node"]),
    },
    {
        settingText = L["mainHand"],
        settingKey = "mainHand",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["mainHand_node"]),
    },
    {
        settingText = L["offHand"],
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
local function getProfessionName(professionIndex)
    if professionIndex then
        local name, _, _, _, _, _, _, _, _, _ =
            GetProfessionInfo(professionIndex)
        return name
    end
    return "None"
end

-- Check if the player has the right profession: Blacksmithing
function CheckProfession()
    local prof1, prof2, _, _, _ = GetProfessions()

    local name1 = getProfessionName(prof1)
    local name2 = getProfessionName(prof2)

    if (name1 ~= "Forge" and name2 ~= "Forge") then -- vérifier blacksmithing
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
