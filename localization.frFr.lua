local _, L = ...
if GetLocale() == "frFR" then
    --- Main
    L["FORMAT_MONEY"] = "%d or, %d argent, %d bronze"
    L["MAIN_FRAME_TITLE"] = "EMH : Marteau de maître terrestre"
    L["SUB_TITLE"] = "En réparant votre équipement avec EMH, vous avec économisé :"
    L["MAIN_TO_SETTINGS_BUTTON"] = "Ouvrir les paramètres"
    L["LOADING"] = "Chargement..."
    L["NO_EMH"] =
    "Attention : Il semblerait que vous n'ayez pas le Marteau de maître terrestre dans votre inventaire. Soyez sûr de l'avoir avant d'essayer d'utiliser l'addon EMH."
    L["NO_REPAIR"] = "Aucune réparation nécessaire"
    L["SAVED_MONEY_PRINT"] = "Vous venez d'économiser %s grâce à EMH."
    L["REPAIR_BUTTON"] = "Réparer %s (%d/%d)"
    L["MACRO"] = "/use Marteau de maître terrestre\n/use %d"
    L["GOLD_TOOLTIP"] =
    "En raison de limitations de l'API de Blizzard, le montant affiché ne prend en compte que les économies réalisées lors de l'utilisation d'EMH avec une fenêtre de réparateur ouverte."
    L["CREDITS"] = "EMH - version %s - par Iryon"

    -- Items names
    L["mainHand"] = "Main principale"
    L["offHand"] = "Main secondaire"

    --- Settings
    L["SETTINGS_FRAME_TITLE"] = "EMH : Marteau de maître terrestre - Paramètres"
    L["SETTINGS_TO_MAIN_BUTTON"] = "Fermer les paramètres"
    L["SETTINGS_SUB_TITLE"] = "Veuillez cocher les objets que vous pouvez réparer :"
    L["SETTINGS_SUB_TITLE_NOTE_1"] =
    "(Note : Vous ne pouvez réparer que les objets dont le noeud de spécialisation"
    L["SETTINGS_SUB_TITLE_NOTE_2"] = "est au niveau maximal)"
    L["SETTINGS_TOOLTIP"] = "Cochez l'option si vous avez le noeud de spécialisation %s au niveau maximal."
    -- Nodes
    L["head_node"] = "'Heaumes'"
    L["shoulder_node"] = "'Espauliers'"
    L["chest_node"] = "'Cuirasses'"
    L["waist_node"] = "'Ceintures'"
    L["legs_node"] = "'Grèves'"
    L["feet_node"] = "'Solerets'"
    L["wrists_node"] = "'Protège-bras'"
    L["hands_node"] = "'Gantelets'"
    L["mainHand_node"] =
    "de votre arme équipée en main droite ('Haches et armes d'hast' / 'Lames longues' / 'Lames courtes' / 'Masse' )"
    L["offHand_node"] =
    "de votre objet équipé en main gauche ('Boucliers' / 'Lames courtes' / 'Lames longues' / 'Masse')"
end
