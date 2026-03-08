-- Translated thanks to Fenei

local _, L = ...

if GetLocale() == "zhCN" then
    --- Main
    L["MAIN_FRAME_TITLE"] = "EMH：土灵大师之锤"
    L["SUB_TITLE"] = "通过使用EMH修理装备，您已节省："
    L["MAIN_TO_SETTINGS_BUTTON"] = "打开设置"
    L["LOADING"] = "加载中..."
    -- L["NO_EMH"]                    =
    -- "Warning: No Master's Hammer found in your bags. Make sure you have one before using the addon."
    -- L["NO_BLACKSMITHING"]          = "EMH: No Blacksmithing profession detected. Addon disabled."
    -- L["NO_REPAIR_NODES"]           =
    -- "EMH: No repair specialization nodes unlocked. Addon disabled. Use /emhcap to inspect detected capabilities."
    L["NO_REPAIR"] = "无需修理"
    L["SAVED_MONEY_PRINT"] = "您通过使用EMH节省了 %s。"
    L["REPAIR_BUTTON"] = "修理 %s (%d/%d): %d%%"
    L["GOLD_TOOLTIP"] = "由于暴雪API限制，显示金额仅包含打开修理窗口时使用EMH的节省。"
    L["CREDITS"] = "EMH - v%s - by Iryon"

    -- Durability command
    -- L["DURABILITY_TITLE"] =
    -- L["DURABILITY_INFO"] =
    -- L["DURABILITY_FULL"] =

    --- Settings
    L["SETTINGS_FRAME_TITLE"] = "EMH：土灵大师之锤 - 设置"
    L["SETTINGS_TO_MAIN_BUTTON"] = "返回主界面"
    -- L["SETTINGS_SUB_TITLE"] = "请勾选您可以修理的装备类型："
    -- L["SETTINGS_SUB_TITLE_NOTE_1"] = "（注意：只能修理已学习最高等级专业节点的装备）"
    L["SETTINGS_TOOLTIP"] = "勾选此项表示您已学习%s专业节点的最高等级。"

    -- Frame Control
    L["COMPARTMENT_LEFT"] = "左键点击打开主界面"
    L["COMPARTMENT_RIGHT"] = "右键点击打开设置"
    -- L["COMPARTMENT_INCOMBAT"] =
    L["EMH"] = "土灵大师之锤"

    -- -- Capabilities display
    -- -- ARMOR
    -- L["CAP_ARMOR"]                 = "Armor"
    -- L["CAP_head"]                  = "'Helms'"
    -- L["CAP_shoulder"]              = "'Pauldrons'"
    -- L["CAP_chest"]                 = "'Breastplates'"
    -- L["CAP_waist"]                 = "'Belts'"
    -- L["CAP_legs"]                  = "'Greaves'"
    -- L["CAP_feet"]                  = "'Sabatons'"
    -- L["CAP_wrists"]                = "'Vambraces'"
    -- L["CAP_hands"]                 = "'Gauntlets'"
    -- -- WEAPONS
    -- L["CAP_WEAPONS"]               = "Weapons"
    -- L["CAP_short_blades"]          = "'Short Blades'"
    -- L["CAP_long_blades"]           = "'Long Blades'"
    -- L["CAP_axes_and_polearms"]     = "'Axes & Polearms'"
    -- L["CAP_maces"]                 = "'Maces'"
    -- L["CAP_shields"]               = "'Shields'"
    -- -- MISC
    -- L["CAP_HAMMERS"]               = "Hammers"
    -- L["CAP_SOURCE_MIDNIGHT"]       = "MN"
    -- L["CAP_SOURCE_TWW"]            = "TWW"
    -- L["CAP_IN_BAGS"]               = "In bags"
    -- L["CAP_NOT_IN_BAGS"]           = "Not in bags"
    -- L["CAP_COMMAND_TITLE"]         = "=== EMH: Detected capabilities ==="
    -- L["CAP_main_hand"]             = "Main Hand"
    -- L["CAP_off_hand"]              = "Off Hand"


    -- Errors and warning
    -- L["CANT_OPEN_IN_COMBAT"] =
    L["ERROR_BAD_TYPE_NUMBER"] = "错误：预期数字类型，实际得到 %s"
    L["ERROR_NO_NAME_IN_EMHDB"] = "错误：NAME_TO_ID中找不到%s对应的元素"
    L["ERROR_REMOVE_EMHDB"] = "错误：尝试从数据库删除ID为'%s'的元素时出错"
    L["ERROR_ADD_EMHDB"] = "错误：数据库已存在ID为'%s'的元素"
    L["ERROR_NOT_A_FRAME"] = "错误：%s参数错误，预期得到框架对象"
end
