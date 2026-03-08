-- Translated thanks to ZamestoTV (@Hubbotu)
-- Lines marked with Automatically translated were added after the initial translation and may require review.

local _, L = ...

if GetLocale() == "ruRU" then
    --- Main
    L["MAIN_FRAME_TITLE"] = "TMH: Thalassian Master Hammer"
    L["SUB_TITLE"] = "Благодаря ремонту вашего снаряжения с помощью TMH, вы сэкономили:"
    L["MAIN_TO_SETTINGS_BUTTON"] = "Перейти к настройкам"
    L["LOADING"] = "Загрузка..."
    L["NO_EMH"] =
    "Внимание: Ремонтный молот талассийского мастера не найден в ваших сумках. Убедитесь, что он у вас есть, прежде чем использовать аддон." -- Automatically translated
    L["NO_BLACKSMITHING"] = "TMH: Профессия кузнечного дела не обнаружена. Аддон отключен." -- Automatically translated
    L["NO_REPAIR_NODES"] =
    "TMH: Узлы специализации по ремонту не разблокированы. Аддон отключен. Используйте /tmhcap для проверки обнаруженных возможностей." -- Automatically translated
    L["NO_REPAIR"] = "Ремонт не требуется"
    L["SAVED_MONEY_PRINT"] = "Вы только что сэкономили %s, используя TMH."
    L["REPAIR_BUTTON"] = "Ремонт %s (%d/%d): %d%%"
    L["MACRO"] = "/use item:%d\n/use %d"
    L["GOLD_TOOLTIP"] =
    "Из-за ограничений API Blizzard отображаемая сумма учитывает только экономию, полученную при использовании TMH с открытым окном ремонта."
    L["CREDITS"] = "TMH - v%s - от Iryon"

    -- Durability command
    L["DURABILITY_TITLE"] = "Прочность предметов:" -- Automatically translated
    L["DURABILITY_INFO"] = "- %s -> %d%%" -- Automatically translated
    L["DURABILITY_FULL"] = "Ни один предмет не нуждается в ремонте." -- Automatically translated

    --- Settings
    L["SETTINGS_FRAME_TITLE"] = "TMH: Thalassian Master Hammer - Настройки"
    L["SETTINGS_TO_MAIN_BUTTON"] = "Перейти к основному окну"
    L["SETTINGS_SUB_TITLE"] = "Вы можете отремонтировать..." -- Automatically translated
    L["SETTINGS_SUB_TITLE_NOTE_1"] =
    "(|cff00ff00ОК|r / |cffffff00Отсутствует узел или молот|r / |cffff4444Отсутствует и то, и другое|r)" -- Automatically translated
    L["SETTINGS_TOOLTIP"] = "Отметьте галочку, если у вас есть узел кузнечного дела %s на максимальном уровне."
    -- Item names in settings
    L["mainHandSettings"] = "Основное оружие"
    L["offHandSettings"] = "Дополнительное оружие"

    -- Frame Control
    L["COMPARTMENT_LEFT"] = "ЛКМ, чтобы открыть основное окно"
    L["COMPARTMENT_RIGHT"] = "ПКМ, чтобы открыть настройки"
    L["COMPARTMENT_INCOMBAT"] = "Вы не можете открыть окно TMH во время боя" -- Automatically translated
    L["TMH"] = "Ремонтный молот талассийского мастера" -- Automatically translated

    -- -- Capabilities display
    -- -- ARMOR
    L["CAP_ARMOR"] = "Броня" -- Automatically translated
    L["CAP_head"] = "'Шлемы'" -- Automatically translated
    L["CAP_shoulder"] = "'Наплечники'" -- Automatically translated
    L["CAP_chest"] = "'Нагрудники'" -- Automatically translated
    L["CAP_waist"] = "'Пояса'" -- Automatically translated
    L["CAP_legs"] = "'Поножи'" -- Automatically translated
    L["CAP_feet"] = "'Сапоги'" -- Automatically translated
    L["CAP_wrists"] = "'Поручи'" -- Automatically translated
    L["CAP_hands"] = "'Перчатки'" -- Automatically translated
    -- -- WEAPONS
    L["CAP_WEAPONS"] = "Оружие" -- Automatically translated
    L["CAP_short_blades"] = "'Короткие клинки'" -- Automatically translated
    L["CAP_long_blades"] = "'Длинные клинки'" -- Automatically translated
    L["CAP_axes_and_polearms"] = "'Топоры и древковое'" -- Automatically translated
    L["CAP_maces"] = "'Дробящее'" -- Automatically translated
    L["CAP_shields"] = "'Щиты'" -- Automatically translated
    -- -- MISC
    L["CAP_HAMMERS"] = "Молоты" -- Automatically translated
    L["CAP_SOURCE_MIDNIGHT"] = "MN" -- Automatically translated
    L["CAP_SOURCE_TWW"] = "TWW" -- Automatically translated
    L["CAP_IN_BAGS"] = "В сумках" -- Automatically translated
    L["CAP_NOT_IN_BAGS"] = "Нет в сумках" -- Automatically translated
    L["CAP_COMMAND_TITLE"] = "=== TMH: Обнаруженные возможности ===" -- Automatically translated
    L["CAP_main_hand"] = "Правая рука" -- Automatically translated
    L["CAP_off_hand"] = "Левая рука" -- Automatically translated

    -- Errors and warning
    L["CANT_OPEN_IN_COMBAT"] = "Невозможно открыть во время боя" -- Automatically translated
    L["ERROR_BAD_TYPE_NUMBER"] = "ОШИБКА: Ожидалось число, получено %s"
    L["ERROR_NO_NAME_IN_EMHDB"] = "ОШИБКА: Предмет с названием %s отсутствует в NAME_TO_ID."
    L["ERROR_REMOVE_EMHDB"] = "ОШИБКА: Ошибка при попытке удалить предмет с id '%s' из базы данных."
    L["ERROR_ADD_EMHDB"] = "ОШИБКА: Предмет с id '%s' уже существует в базе данных."
    L["ERROR_NOT_A_FRAME"] = "ОШИБКА: Неверный аргумент передан в %s, ожидался фрейм."
end
