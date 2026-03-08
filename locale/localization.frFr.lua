-- Original version by Iryon

local _, L = ...

if GetLocale() == "frFR" then
    --- Main
    L["MAIN_FRAME_TITLE"]          = "TMH : Thalassian Master Hammer"
    L["SUB_TITLE"]                 = "En réparant votre équipement avec TMH, vous avec économisé :"
    L["MAIN_TO_SETTINGS_BUTTON"]   = "Ouvrir les paramètres"
    L["LOADING"]                   = "Chargement..."
    L["NO_EMH"]                    =
    "Attention : Aucun Marteau de maître n'a été trouvé dans vos sacs. Assurez-vous d'en avoir un avant d'utiliser l'addon."
    L["NO_BLACKSMITHING"]          = "TMH : Aucun métier de Forge détecté. Addon désactivé."
    L["NO_REPAIR_NODES"]           =
    "TMH : Aucun noeud de spécialisation de réparation débloqué. Addon désactivé. Utilisez /tmhcap pour inspecter les capacités détectées."
    L["NO_REPAIR"]                 = "Aucune réparation nécessaire"
    L["SAVED_MONEY_PRINT"]         = "Vous venez d'économiser %s grâce à TMH."
    L["REPAIR_BUTTON"]             = "Réparer %s (%d/%d) : %d%%"
    L["MACRO"]                     = "/use item:%d\n/use %d"
    L["GOLD_TOOLTIP"]              =
    "En raison de limitations de l'API de Blizzard, le montant affiché ne prend en compte que les économies réalisées lors de l'utilisation d'TMH avec une fenêtre de réparateur ouverte."
    L["CREDITS"]                   = "TMH - version %s - par Iryon"

    -- Durability command
    L["DURABILITY_TITLE"]          = "Durabilité des objets :"
    L["DURABILITY_INFO"]           = "- %s -> %d%%"
    L["DURABILITY_FULL"]           = "Aucun objet n'a besoin d'être réparé."

    --- Settings
    L["SETTINGS_FRAME_TITLE"]      = "TMH : Thalassian Master Hammer - Paramètres"
    L["SETTINGS_TO_MAIN_BUTTON"]   = "Fermer les paramètres"
    L["SETTINGS_SUB_TITLE"]        = "Vous pouvez réparer..."
    L["SETTINGS_SUB_TITLE_NOTE_1"] = "(|cff00ff00OK|r / |cffffff00Manque node ou marteau|r / |cffff4444Manque tout|r)"

    -- Frame Control
    L["COMPARTMENT_LEFT"]          = "Clic gauche pour ouvrir la fenêtre principale"
    L["COMPARTMENT_RIGHT"]         = "Clic droit pour ouvrir les paramètres"
    L["COMPARTMENT_INCOMBAT"]      = "Impossible d'ouvrir la fenêtre TMH en combat"
    L["EMH"]                       = "Thalassian Master Hammer"

    -- Capabilities display
    -- ARMOR
    L["CAP_ARMOR"]                 = "Armure"
    L["CAP_head"]                  = "'Heaumes'"
    L["CAP_shoulder"]              = "'Espauliers'"
    L["CAP_chest"]                 = "'Cuirasses'"
    L["CAP_waist"]                 = "'Ceintures'"
    L["CAP_legs"]                  = "'Grèves'"
    L["CAP_feet"]                  = "'Solerets'"
    L["CAP_wrists"]                = "'Protège-bras'"
    L["CAP_hands"]                 = "'Gantelets'"
    -- WEAPONS
    L["CAP_WEAPONS"]               = "Armes"
    L["CAP_short_blades"]          = "'Lames courtes'"
    L["CAP_long_blades"]           = "'Lames longues'"
    L["CAP_axes_and_polearms"]     = "'Haches et armes d'hast'"
    L["CAP_maces"]                 = "'Masse'"
    L["CAP_shields"]               = "'Boucliers'"
    -- MISC
    L["CAP_HAMMERS"]               = "Marteaux"
    L["CAP_SOURCE_MIDNIGHT"]       = "MN"
    L["CAP_SOURCE_TWW"]            = "TWW"
    L["CAP_IN_BAGS"]               = "Dans les sacs"
    L["CAP_NOT_IN_BAGS"]           = "Absent des sacs"
    L["CAP_COMMAND_TITLE"]         = "=== TMH : Capacités détectées ==="
    L["CAP_main_hand"]             = "Arme principale"
    L["CAP_off_hand"]              = "Arme secondaire"


    -- Errors and warning
    L["CANT_OPEN_IN_COMBAT"]    = "Vous ne pouvez pas ouvrir la fenêtre TMH en combat."
    L["ERROR_BAD_TYPE_NUMBER"]  = "ERREUR : Élément de type number attendu, mais reçu un type %s"
    L["ERROR_NO_NAME_IN_EMHDB"] = "ERREUR: Pas d'élément avec le nom %s dans NAME_TO_ID."
    L["ERROR_REMOVE_EMHDB"]     = "ERREUR: Erreur lors de la suppression de l'élément avec l'id '%s' de la base de données."
    L["ERROR_ADD_EMHDB"]        = "ERREUR : L'élément avec l'id '%s' existe déjà dans la base de données."
    L["ERROR_NOT_A_FRAME"]      = "ERREUR: Mauvais paramètre passé à la fonction %s, une frame était attendue."
end
