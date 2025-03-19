-- Translated thanks to ZamestoTV (@Hubbotu)

local _, L = ...

if GetLocale() == "ruRU" then
    --- Main
    L["FORMAT_MONEY"] = "%s золота, %d серебра, %d меди"
    L["MAIN_FRAME_TITLE"] = "EMH: Earthen Master's Hammer"
    L["SUB_TITLE"] = "Благодаря ремонту вашего снаряжения с помощью EMH, вы сэкономили:"
    L["MAIN_TO_SETTINGS_BUTTON"] = "Перейти к настройкам"
    L["LOADING"] = "Загрузка..."
    L["NO_EMH"] =
    "Внимание: Похоже, что у вас в инвентаре нет Молотка земельника-мастера. Пожалуйста, убедитесь, что он у вас есть, прежде чем использовать аддон."
    L["NO_REPAIR"] = "Ремонт не требуется"
    L["SAVED_MONEY_PRINT"] = "Вы только что сэкономили %s, используя EMH."
    L["REPAIR_BUTTON"] = "Ремонт %s (%d/%d)"
    L["MACRO"] = "/use item:%d\n/use %d"
    L["GOLD_TOOLTIP"] =
    "Из-за ограничений API Blizzard отображаемая сумма учитывает только экономию, полученную при использовании EMH с открытым окном ремонта."
    L["CREDITS"] = "EMH - v%s - от Iryon"

    -- Item names
    L["head"] = "головной убор"
    L["shoulder"] = "наплечники"
    L["chest"] = "нагрудник"
    L["waist"] = "пояс"
    L["legs"] = "поножи"
    L["feet"] = "обувь"
    L["wrist"] = "наручи"
    L["hands"] = "перчатки"
    L["mainHand"] = "основное оружие"
    L["offHand"] = "дополнительное оружие"

    --- Settings
    L["SETTINGS_FRAME_TITLE"] = "EMH: Earthen Master's Hammer - Настройки"
    L["SETTINGS_TO_MAIN_BUTTON"] = "Перейти к основному окну"
    L["SETTINGS_SUB_TITLE"] = "Пожалуйста, отметьте предметы, которые вы можете ремонтировать:"
    L["SETTINGS_SUB_TITLE_NOTE_1"] =
    "(Примечание: Вы можете ремонтировать только предметы с максимальным уровнем специализации.)"
    L["SETTINGS_SUB_TITLE_NOTE_2"] = "(Убедитесь, что выбрали правильные предметы.)"
    L["SETTINGS_TOOLTIP"] = "Отметьте галочку, если у вас есть узел кузнечного дела %s на максимальном уровне."
    -- Item names in settings
    L["mainHandSettings"] = "Основное оружие"
    L["offHandSettings"] = "Дополнительное оружие"

    -- Frame Control
    L["COMPARTMENT_LEFT"] = "ЛКМ, чтобы открыть основное окно"
    L["COMPARTMENT_RIGHT"] = "ПКМ, чтобы открыть настройки"
    L["EMH"] = "Молоток земельника-мастера"

    -- Nodes
    L["head_node"] = "'Шлемы'"
    L["shoulder_node"] = "'Наплечники'"
    L["chest_node"] = "'Нагрудники'"
    L["waist_node"] = "'Пояса'"
    L["legs_node"] = "'Поножи'"
    L["feet_node"] = "'Сапоги'"
    L["wrists_node"] = "'Наручи'"
    L["hands_node"] = "'Перчатки'"
    L["mainHand_node"] = "для основного оружия ('Топоры и алебарды' / 'Длинные клинки' / 'Короткие клинки' / 'Булавы')"
    L["offHand_node"] = "для дополнительного оружия ('Щиты' / 'Короткие клинки' / 'Длинные клинки' / 'Булавы')"

    -- Errors and warning
    L["ERROR_BAD_TYPE_NUMBER"] = "ОШИБКА: Ожидалось число, получено %s"
    L["ERROR_NO_NAME_IN_EMHDB"] = "ОШИБКА: Предмет с названием %s отсутствует в NAME_TO_ID."
    L["ERROR_REMOVE_EMHDB"] = "ОШИБКА: Ошибка при попытке удалить предмет с id '%s' из базы данных."
    L["ERROR_ADD_EMHDB"] = "ОШИБКА: Предмет с id '%s' уже существует в базе данных."
    L["ERROR_NOT_A_FRAME"] = "ОШИБКА: Неверный аргумент передан в %s, ожидался фрейм."
end
