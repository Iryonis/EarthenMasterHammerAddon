-- Translated thanks to Fenei

local _, L = ...

if GetLocale() == "zhCN" then
    --- Main
    L["FORMAT_MONEY"] = "%s 金，%d 银，%d 铜"
    L["MAIN_FRAME_TITLE"] = "EMH：土灵大师之锤"
    L["SUB_TITLE"] = "通过使用EMH修理装备，您已节省："
    L["MAIN_TO_SETTINGS_BUTTON"] = "打开设置"
    L["LOADING"] = "加载中..."
    L["NO_EMH"] = "警告：当前背包中没有土灵大师之锤。请在使用插件前确保已获取该物品。"
    L["NO_REPAIR"] = "无需修理"
    L["SAVED_MONEY_PRINT"] = "您通过使用EMH节省了 %s。"
    L["REPAIR_BUTTON"] = "修理 %s (%d/%d)"
    L["GOLD_TOOLTIP"] = "由于暴雪API限制，显示金额仅包含打开修理窗口时使用EMH的节省。"
    L["CREDITS"] = "EMH - v%s - by Iryon"

    -- Item names
    L["head"] = "头部"
    L["shoulder"] = "肩部"
    L["chest"] = "胸部"
    L["waist"] = "腰部"
    L["legs"] = "腿部"
    L["feet"] = "脚部"
    L["wrist"] = "手腕"
    L["hands"] = "手部"
    L["mainHand"] = "主手武器"
    L["offHand"] = "副手物品"

    --- Settings
    L["SETTINGS_FRAME_TITLE"] = "EMH：土灵大师之锤 - 设置"
    L["SETTINGS_TO_MAIN_BUTTON"] = "返回主界面"
    L["SETTINGS_SUB_TITLE"] = "请勾选您可以修理的装备类型："
    L["SETTINGS_SUB_TITLE_NOTE_1"] = "（注意：只能修理已学习最高等级专业节点的装备）"
    L["SETTINGS_SUB_TITLE_NOTE_2"] = "（请确保选择正确的装备类型）"
    L["SETTINGS_TOOLTIP"] = "勾选此项表示您已学习%s专业节点的最高等级。"

    -- Frame Control
    L["COMPARTMENT_LEFT"] = "左键点击打开主界面"
    L["COMPARTMENT_RIGHT"] = "右键点击打开设置"
    L["EMH"] = "土灵大师之锤"

    -- Nodes
    L["head_node"] = "'头盔'"
    L["shoulder_node"] = "'护肩'"
    L["chest_node"] = "'胸甲'"
    L["waist_node"] = "'腰带'"
    L["legs_node"] = "'腿甲'"
    L["feet_node"] = "'战靴'"
    L["wrists_node"] = "'护腕'"
    L["hands_node"] = "'护手'"
    L["mainHand_node"] = "主手武器（'战斧与长柄武器'/'长剑'/'短剑'/'锤类武器'）"
    L["offHand_node"] = "副手物品（'盾牌'/'短剑'/'长剑'/'锤类武器'）"

    -- Errors and warning
    L["ERROR_BAD_TYPE_NUMBER"] = "错误：预期数字类型，实际得到 %s"
    L["ERROR_NO_NAME_IN_EMHDB"] = "错误：NAME_TO_ID中找不到%s对应的元素"
    L["ERROR_REMOVE_EMHDB"] = "错误：尝试从数据库删除ID为'%s'的元素时出错"
    L["ERROR_ADD_EMHDB"] = "错误：数据库已存在ID为'%s'的元素"
    L["ERROR_NOT_A_FRAME"] = "错误：%s参数错误，预期得到框架对象"
end
