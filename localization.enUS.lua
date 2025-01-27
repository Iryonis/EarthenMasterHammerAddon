local addonName, L = ...; -- Let's use the private table passed to every .lua file to store our locale
local function defaultFunc(L, key)
    -- If this function was called, we have no localization for this key.
    -- We could complain loudly to allow localizers to see the error of their ways,
    -- but, for now, just return the key as its own localization. This allows you to
    -- avoid writing the default localization out explicitly.
    return key;
end
setmetatable(L, { __index = defaultFunc });

--- Main
L["FORMAT_MONEY"] = "%d gold, %d silver, %d copper";
L["MAIN_FRAME_TITLE"] = "EMH: Earthen Masters's Hammer";
L["SUB_TITLE"] = "By repairing your gear with EMH, you have saved:";
L["MAIN_TO_SETTINGS_BUTTON"] = "Switch to settings";
L["LOADING"] = "Loading...";
L["NO_EMH"] =
"Oops, it seems that you currently don't have the Earthen Master's Hammer in your inventory. Please make sure to get it before using the addon.";
L["NO_REPAIR"] = "No repair needed"
L["SAVED_MONEY_PRINT"] = "You just saved %s using EMH."
L["REPAIR_BUTTON"] = "Repair %s (%d/%d)";
L["MACRO"] = "/use Earthen Master's Hammer\n/use %d";

-- Items names
L["head"] = "head item";
L["shoulder"] = "shoulder item";
L["chest"] = "chest item";
L["waist"] = "waist item";
L["legs"] = "legs item";
L["feet"] = "feet item";
L["wrists"] = "wrists item";
L["hands"] = "hands item";
L["mainHand"] = "main hand item";
L["offHand"] = "off hand item";

--- Settings
L["SETTINGS_FRAME_TITLE"] = "EMH: Earthen Masters's Hammer - Settings";
L["SETTINGS_TO_MAIN_BUTTON"] = "Switch to main";
L["SETTINGS_SUB_TITLE"] = "Please check the items you can repair:";
L["SETTINGS_SUB_TITLE_NOTE_1"] = "(Note: You can only repair items with a max level specialization node.)";
L["SETTINGS_TOOLTIP"] = "Cochez l'option si vous avez le noeud de Forge '%s' au niveau maximum.";

-- Nodes
L["head_node"] = "";
L["shoulder_node"] = "";
L["chest_node"] = "";
L["waist_node"] = "";
L["legs_node"] = "";
L["feet_node"] = "";
L["wrists_node"] = "";
L["hands_node"] = "";
L["mainHand_node"] = "";
L["offHand_node"] = "";
