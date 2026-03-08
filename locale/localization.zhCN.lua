-- Translated thanks to Fenei
-- Lines marked with Automatically translated were added after the initial translation and may require review.

local _, L = ...

if GetLocale() == "zhCN" then
    --- Main
    L["MAIN_FRAME_TITLE"] = "TMH：土灵大师之锤"
    L["SUB_TITLE"] = "通过使用TMH修理装备，您已节省："
    L["MAIN_TO_SETTINGS_BUTTON"] = "打开设置"
    L["LOADING"] = "加载中..."
    L["NO_EMH"] = "警告：在您的背包中未找到萨拉斯大师修理锤。请在使用插件前确保您拥有一个。" -- Automatically translated
    L["NO_BLACKSMITHING"] = "TMH：未检测到锻造专业。插件已禁用。" -- Automatically translated
    L["NO_REPAIR_NODES"] = "TMH：未解锁修理专业节点。插件已禁用。请使用 /tmhcap 查看检测到的能力。" -- Automatically translated
    L["NO_REPAIR"] = "无需修理"
    L["SAVED_MONEY_PRINT"] = "您通过使用TMH节省了 %s。" -- Automatically translated
    L["REPAIR_BUTTON"] = "修理 %s (%d/%d): %d%%"
    L["GOLD_TOOLTIP"] = "由于暴雪API限制，显示金额仅包含打开修理窗口时使用TMH的节省。" -- Automatically translated
    L["CREDITS"] = "TMH - v%s - by Iryon" -- Automatically translated

    -- Durability command
    L["DURABILITY_TITLE"] = "物品耐久度：" -- Automatically translated
    L["DURABILITY_INFO"] = "- %s -> %d%%" -- Automatically translated
    L["DURABILITY_FULL"] = "没有物品需要修理。" -- Automatically translated

    --- Settings
    L["SETTINGS_FRAME_TITLE"] = "TMH：萨拉斯大师修理锤 - 设置" -- Automatically translated
    L["SETTINGS_TO_MAIN_BUTTON"] = "返回主界面"
    L["SETTINGS_SUB_TITLE"] = "您可以修理..." -- Automatically translated
    L["SETTINGS_SUB_TITLE_NOTE_1"] =
    "(|cff00ff00OK|r / |cffffff00缺少节点或锤子|r / |cffff4444两者都缺少|r)" -- Automatically translated
    L["SETTINGS_TOOLTIP"] = "勾选此项表示您已学习%s专业节点的最高等级。"

    -- Frame Control
    L["COMPARTMENT_LEFT"] = "左键点击打开主界面"
    L["COMPARTMENT_RIGHT"] = "右键点击打开设置"
    L["COMPARTMENT_INCOMBAT"] = "您不能在战斗中打开TMH界面" -- Automatically translated
    L["TMH"] = "萨拉斯大师修理锤" -- Automatically translated

    -- -- Capabilities display
    -- -- ARMOR
    L["CAP_ARMOR"] = "护甲" -- Automatically translated
    L["CAP_head"] = "'头盔'" -- Automatically translated
    L["CAP_shoulder"] = "'护肩'" -- Automatically translated
    L["CAP_chest"] = "'胸甲'" -- Automatically translated
    L["CAP_waist"] = "'腰带'" -- Automatically translated
    L["CAP_legs"] = "'腿甲'" -- Automatically translated
    L["CAP_feet"] = "'鞋子'" -- Automatically translated
    L["CAP_wrists"] = "'护腕'" -- Automatically translated
    L["CAP_hands"] = "'手套'" -- Automatically translated
    -- -- WEAPONS
    L["CAP_WEAPONS"] = "武器" -- Automatically translated
    L["CAP_short_blades"] = "'短刃'" -- Automatically translated
    L["CAP_long_blades"] = "'长刃'" -- Automatically translated
    L["CAP_axes_and_polearms"] = "'斧和长柄武器'" -- Automatically translated
    L["CAP_maces"] = "'锤'" -- Automatically translated
    L["CAP_shields"] = "'盾牌'" -- Automatically translated
    -- -- MISC
    L["CAP_HAMMERS"] = "锤" -- Automatically translated
    L["CAP_SOURCE_MIDNIGHT"] = "MN" -- Automatically translated
    L["CAP_SOURCE_TWW"] = "TWW" -- Automatically translated
    L["CAP_IN_BAGS"] = "在背包中" -- Automatically translated
    L["CAP_NOT_IN_BAGS"] = "不在背包中" -- Automatically translated
    L["CAP_COMMAND_TITLE"] = "=== TMH: 检测到的能力 ===" -- Automatically translated
    L["CAP_main_hand"] = "主手" -- Automatically translated
    L["CAP_off_hand"] = "副手" -- Automatically translated


    -- Errors and warning
    L["CANT_OPEN_IN_COMBAT"] = "战斗中无法打开" -- Automatically translated
    L["ERROR_BAD_TYPE_NUMBER"] = "错误：预期数字类型，实际得到 %s"
    L["ERROR_NO_NAME_IN_EMHDB"] = "错误：NAME_TO_ID中找不到%s对应的元素"
    L["ERROR_REMOVE_EMHDB"] = "错误：尝试从数据库删除ID为'%s'的元素时出错"
    L["ERROR_ADD_EMHDB"] = "错误：数据库已存在ID为'%s'的元素"
    L["ERROR_NOT_A_FRAME"] = "错误：%s参数错误，预期得到框架对象"
end
