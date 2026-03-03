-- Translated by Iryon

local _, L = ...

local function defaultFunc(L, key)
    return key
end

setmetatable(L, { __index = defaultFunc })

--- Main
L["FORMAT_MONEY"]              = "%s gold, %d silver, %d copper"
L["MAIN_FRAME_TITLE"]          = "EMH: Earthen Master's Hammer"
L["SUB_TITLE"]                 = "By repairing your gear with EMH, you have saved:"
L["MAIN_TO_SETTINGS_BUTTON"]   = "Switch to settings"
L["LOADING"]                   = "Loading..."
L["NO_EMH"]                    =
"Warning: No Master's Hammer found in your bags. Make sure you have one before using the addon."
L["NO_BLACKSMITHING"]          = "EMH: No Blacksmithing profession detected. Addon disabled."
L["NO_REPAIR_NODES"]           =
"EMH: No repair specialization nodes unlocked. Addon disabled. Use /emhcap to inspect detected capabilities."
L["NO_REPAIR"]                 = "No repair needed"
L["SAVED_MONEY_PRINT"]         = "You just saved %s using EMH."
L["REPAIR_BUTTON"]             = "Repair %s (%d/%d): %d%%"
L["MACRO"]                     = "/use item:%d\n/use %d"
L["GOLD_TOOLTIP"]              =
"Due to limitations in Blizzard's API, the displayed amount only accounts for the savings made when using EMH while having a repair frame open."
L["CREDITS"]                   = "EMH - v%s - by Iryon"

-- Durability command
L["DURABILITY_TITLE"]          = "Item durability:"
L["DURABILITY_INFO"]           = "- %s -> %d%%"
L["DURABILITY_FULL"]           = "No item needs to be repaired."

--- Settings
L["SETTINGS_FRAME_TITLE"]      = "EMH: Earthen Master's Hammer - Settings"
L["SETTINGS_TO_MAIN_BUTTON"]   = "Switch to main"
L["SETTINGS_SUB_TITLE"]        = "You can repair..."
L["SETTINGS_SUB_TITLE_NOTE_1"] = "(|cff00ff00OK|r / |cffffff00Missing node or hammer|r / |cffff4444Missing both|r)"

-- Frame Control
L["COMPARTMENT_LEFT"]          = "Left-click to open main frame"
L["COMPARTMENT_RIGHT"]         = "Right-click to open settings"
L["COMPARTMENT_INCOMBAT"]      = "You can't open the EMH frame while in combat"
L["EMH"]                       = "Earthen Master's Hammer"

-- Capabilities display
-- ARMOR
L["CAP_ARMOR"]                 = "Armor"
L["CAP_head"]                  = "'Helms'"
L["CAP_shoulder"]              = "'Pauldrons'"
L["CAP_chest"]                 = "'Breastplates'"
L["CAP_waist"]                 = "'Belts'"
L["CAP_legs"]                  = "'Greaves'"
L["CAP_feet"]                  = "'Sabatons'"
L["CAP_wrists"]                = "'Vambraces'"
L["CAP_hands"]                 = "'Gauntlets'"
-- WEAPONS
L["CAP_WEAPONS"]               = "Weapons"
L["CAP_short_blades"]          = "'Short Blades'"
L["CAP_long_blades"]           = "'Long Blades'"
L["CAP_axes_and_polearms"]     = "'Axes & Polearms'"
L["CAP_maces"]                 = "'Maces'"
L["CAP_shields"]               = "'Shields'"
-- MISC
L["CAP_HAMMERS"]               = "Hammers"
L["CAP_SOURCE_MIDNIGHT"]       = "MN"
L["CAP_SOURCE_TWW"]            = "TWW"
L["CAP_IN_BAGS"]               = "In bags"
L["CAP_NOT_IN_BAGS"]           = "Not in bags"
L["CAP_COMMAND_TITLE"]         = "=== EMH: Detected capabilities ==="

-- Errors and warning
L["CANT_OPEN_IN_COMBAT"]       = "You can't open the EMH frame while in combat."
L["ERROR_BAD_TYPE_NUMBER"]     = "ERROR: Expected a number, got %s"
L["ERROR_NO_NAME_IN_EMHDB"]    = "ERROR: No element with the name %s in NAME_TO_ID."
L["ERROR_REMOVE_EMHDB"]        = "ERROR: Error while trying to remove element with id '%s' from the database."
L["ERROR_ADD_EMHDB"]           = "ERROR: Element with id '%s' already exists in the database."
L["ERROR_NOT_A_FRAME"]         = "ERROR: Bad argument given to %s, expected a frame."
