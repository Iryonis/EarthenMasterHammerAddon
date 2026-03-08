-- Translated thanks to ZamestoTV (@Hubbotu)

local _, L = ...

if GetLocale() == "ruRU" then
    --- Main
    L["MAIN_FRAME_TITLE"] = "EMH: Earthen Master's Hammer"
    L["SUB_TITLE"] = "Благодаря ремонту вашего снаряжения с помощью EMH, вы сэкономили:"
    L["MAIN_TO_SETTINGS_BUTTON"] = "Перейти к настройкам"
    L["LOADING"] = "Загрузка..."
    -- L["NO_EMH"]                    =
    -- "Warning: No Master's Hammer found in your bags. Make sure you have one before using the addon."
    -- L["NO_BLACKSMITHING"]          = "EMH: No Blacksmithing profession detected. Addon disabled."
    -- L["NO_REPAIR_NODES"]           =
    -- "EMH: No repair specialization nodes unlocked. Addon disabled. Use /emhcap to inspect detected capabilities."
    L["NO_REPAIR"] = "Ремонт не требуется"
    L["SAVED_MONEY_PRINT"] = "Вы только что сэкономили %s, используя EMH."
    L["REPAIR_BUTTON"] = "Ремонт %s (%d/%d): %d%%"
    L["MACRO"] = "/use item:%d\n/use %d"
    L["GOLD_TOOLTIP"] =
    "Из-за ограничений API Blizzard отображаемая сумма учитывает только экономию, полученную при использовании EMH с открытым окном ремонта."
    L["CREDITS"] = "EMH - v%s - от Iryon"

    -- Durability command
    -- L["DURABILITY_TITLE"] =
    -- L["DURABILITY_INFO"] =
    -- L["DURABILITY_FULL"] =

    --- Settings
    L["SETTINGS_FRAME_TITLE"] = "EMH: Earthen Master's Hammer - Настройки"
    L["SETTINGS_TO_MAIN_BUTTON"] = "Перейти к основному окну"
    -- L["SETTINGS_SUB_TITLE"] = "Пожалуйста, отметьте предметы, которые вы можете ремонтировать:"
    -- L["SETTINGS_SUB_TITLE_NOTE_1"] =
    -- "(Примечание: Вы можете ремонтировать только предметы с максимальным уровнем специализации.)"
    L["SETTINGS_TOOLTIP"] = "Отметьте галочку, если у вас есть узел кузнечного дела %s на максимальном уровне."
    -- Item names in settings
    L["mainHandSettings"] = "Основное оружие"
    L["offHandSettings"] = "Дополнительное оружие"

    -- Frame Control
    L["COMPARTMENT_LEFT"] = "ЛКМ, чтобы открыть основное окно"
    L["COMPARTMENT_RIGHT"] = "ПКМ, чтобы открыть настройки"
    -- L["COMPARTMENT_INCOMBAT"] =
    L["EMH"] = "Молоток земельника-мастера"

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
    L["ERROR_BAD_TYPE_NUMBER"] = "ОШИБКА: Ожидалось число, получено %s"
    L["ERROR_NO_NAME_IN_EMHDB"] = "ОШИБКА: Предмет с названием %s отсутствует в NAME_TO_ID."
    L["ERROR_REMOVE_EMHDB"] = "ОШИБКА: Ошибка при попытке удалить предмет с id '%s' из базы данных."
    L["ERROR_ADD_EMHDB"] = "ОШИБКА: Предмет с id '%s' уже существует в базе данных."
    L["ERROR_NOT_A_FRAME"] = "ОШИБКА: Неверный аргумент передан в %s, ожидался фрейм."
end
