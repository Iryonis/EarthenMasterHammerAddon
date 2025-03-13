local _, L = ... -- Let's use the private table passed to every .lua file to store our locale
local function defaultFunc(L, key)
    -- If this function was called, we have no localization for this key.
    -- We could complain loudly to allow localizers to see the error of their ways,
    -- but, for now, just return the key as its own localization. This allows you to
    -- avoid writing the default localization out explicitly.
    return key
end
setmetatable(L, { __index = defaultFunc })

--- Main
L["FORMAT_MONEY"] = "%s gold, %d silver, %d copper"
L["MAIN_FRAME_TITLE"] = "EMH: Earthen Master's Hammer"
L["SUB_TITLE"] = "By repairing your gear with EMH, you have saved:"
L["MAIN_TO_SETTINGS_BUTTON"] = "Switch to settings"
L["LOADING"] = "Loading..."
L["NO_EMH"] =
"Warning: It seems that you currently don't have the Earthen Master's Hammer in your inventory. Please make sure to get it before using the addon."
L["NO_REPAIR"] = "No repair needed"
L["SAVED_MONEY_PRINT"] = "You just saved %s using EMH."
L["REPAIR_BUTTON"] = "Repair %s (%d/%d)"
L["MACRO"] = "/use item:%d\n/use %d"
L["GOLD_TOOLTIP"] =
"Due to limitations in Blizzard's API, the displayed amount only accounts for the savings made when using EMH while having a repair frame open."
L["CREDITS"] = "EMH - v%s - by Iryon"

-- Item names
L["head"] = "head slot"
L["shoulder"] = "shoulder slot"
L["chest"] = "chest slot"
L["waist"] = "waist slot"
L["legs"] = "legs slot"
L["feet"] = "feet slot"
L["wrist"] = "wrist slot"
L["hands"] = "hands slot"
L["mainHand"] = "main hand slot"
L["offHand"] = "off-hand slot"


--- Settings
L["SETTINGS_FRAME_TITLE"] = "EMH: Earthen Master's Hammer - Settings"
L["SETTINGS_TO_MAIN_BUTTON"] = "Switch to main"
L["SETTINGS_SUB_TITLE"] = "Please check the items you can repair:"
L["SETTINGS_SUB_TITLE_NOTE_1"] = "(Note: You can only repair items with a max level specialization node.)"
L["SETTINGS_SUB_TITLE_NOTE_2"] = "(Make sure to select the correct items.)"
L["SETTINGS_TOOLTIP"] = "Check the box if you have the Blacksmithing node %s at max level."
-- Item names in settings
L["mainHandSettings"] = "Main hand item"
L["offHandSettings"] = "Off hand item"

-- Frame Control
L["COMPARTMENT_LEFT"] = "Left-click to open main frame"
L["COMPARTMENT_RIGHT"] = "Right-click to open settings"
L["EMH"] = "Earthen Master's Hammer"

-- Nodes
L["head_node"] = "'Helms'"
L["shoulder_node"] = "'Pauldrons'"
L["chest_node"] = "'Breastplates'"
L["waist_node"] = "'Belts'"
L["legs_node"] = "'Greaves'"
L["feet_node"] = "'Sabatons'"
L["wrists_node"] = "'Vambraces'"
L["hands_node"] = "'Gauntlets'"
L["mainHand_node"] = "for your main hand weapon ('Axes and Polearms' / 'Long Blades' / 'Short Blades' / 'Maces')"
L["offHand_node"] = "for your off-hand item ('Shields' / 'Short Blades' / 'Long Blades' / 'Maces')"

-- Errors and warning
L["ERROR_BAD_TYPE_NUMBER"] = "ERROR: Expected a number, got %s"
L["ERROR_NO_NAME_IN_EMHDB"] = "ERROR: No element with the name %s in NAME_TO_ID."
L["ERROR_REMOVE_EMHDB"] = "ERROR: Error while trying to remove element with id '%s' from the database."
L["ERROR_ADD_EMHDB"] = "ERROR: Element with id '%s' already exists in the database."
L["ERROR_NOT_A_FRAME"] = "ERROR: Bad argument given to %s, expected a frame."
