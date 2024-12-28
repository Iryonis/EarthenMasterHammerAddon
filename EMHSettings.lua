local settings = {
    {
        settingText = "Tête",
        settingKey = "head",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de tête.",
    },
    {
        settingText = "Épaule",
        settingKey = "shoulder",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement d'épaule.",
    },
    {
        settingText = "Torse",
        settingKey = "chest",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de torse.",
    },
    {
        settingText = "Taille",
        settingKey = "waist",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de taille.",
    },
    {
        settingText = "Jambes",
        settingKey = "legs",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de jambes.",
    },
    {
        settingText = "Pieds",
        settingKey = "feet",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de pieds.",
    },
    {
        settingText = "Poignets",
        settingKey = "wrists",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de poignets.",
    },
    {
        settingText = "Mains",
        settingKey = "hands",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de mains.",
    },
    {
        settingText = "Main droite",
        settingKey = "mainHand",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de main droite.",
    },
    {
        settingText = "Main gauche",
        settingKey = "offHand",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement de main gauche.",
    },
    {
        settingText = "À distance",
        settingKey = "ranged",
        settingTooltip = "Si c'est activé, l'addon va utiliser le marteau pour réparer votre équipement à distance.",
    },
}

local nameToId = {
    head = 1,
    shoulder = 3,
    chest = 5,
    waist = 6,
    legs = 7,
    feet = 8,
    wrists = 9,
    hands = 10,
    mainHand = 16,
    offHand = 17,
    ranged = 18,
}

function RemoveByName(name)
    print("Trying to remove name '" .. name .. "' from EMHDB.keys.")
    local id = nameToId[name]
    print(name, id)
    if not id then
        print("Aucune ligne trouvée avec name '" .. name .. "' dans nameToId.")
        return
    end

    for i = #EMHDB.keys, 1, -1 do
        if EMHDB.keys[i] == id then
            table.remove(EMHDB.keys, i)
            print("Ligne avec name '" .. name .. "' a été enlevée de EMHDB.keys.")
            return
        end
    end
    print("Aucune ligne trouvée avec id '" .. id .. "' dans EMHDB.keys.")
end

function AddByName(name)
    local id = nameToId[name]
    if not id then
        print("Aucune ligne trouvée avec name '" .. name .. "' dans nameToId.")
        return
    end

    for _, v in ipairs(EMHDB.keys) do
        if v == id then
            print("Ligne avec name '" .. name .. "' existe déjà dans EMHDB.keys.")
            return
        end
    end

    table.insert(EMHDB.keys, id)
    print("Ligne avec id '" .. id .. "' et name '" .. name .. "' a été ajoutée à EMHDB.keys.")
end

SettingsFrame = CreateFrame("Frame", "EMHMainFrame", UIParent, "BasicFrameTemplateWithInset");

SettingsFrame:SetSize(500, 300);
SettingsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
SettingsFrame.TitleBg:SetHeight(30);
SettingsFrame.title = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
SettingsFrame.title:SetPoint("TOPLEFT", SettingsFrame.TitleBg, "TOPLEFT", 5, -3);
SettingsFrame.title:SetText("Earthen Masters's Hammer - Settings");
SettingsFrame.subTitle = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
local font, _, flags = SettingsFrame.subTitle:GetFont()
if font then
    SettingsFrame.subTitle:SetFont(font, 16, flags)
end
SettingsFrame.subTitle:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 15, -35);
SettingsFrame.subTitle:SetText(
    "Check the items you can repair with the hammer:");
SettingsFrame.subTitleNote = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
SettingsFrame.subTitleNote:SetPoint("TOPLEFT", SettingsFrame.subTitle, "BOTTOMLEFT", 0, -10);
SettingsFrame.subTitleNote:SetText(
    "(Note: You can only repair items with a max level specialization node.)");

-- local MacroButton = CreateFrame("Button", "MyMacroButton", UIParent, "SecureActionButtonTemplate");
-- MacroButton:RegisterForClicks("AnyUp");                              --   Respond to all buttons
-- MacroButton:SetAttribute("type", "macro");                           -- Set type to "macro"
-- MacroButton:SetAttribute("macrotext", "/say Using my Hearthstone."); -- Set our macro text
-- SetBindingClick("ALT-CTRL-F", "MyMacroButton", "MyMacroButton");

-- Button to go back to main frame
local goToMainButton = CreateFrame("Button", "goToMainButton", SettingsFrame, "UIPanelButtonTemplate")
goToMainButton:SetPoint("TOPRIGHT", SettingsFrame, "TOPRIGHT", -25, 0)
goToMainButton:SetSize(150, 20)
goToMainButton:SetText("Switch to main frame")
goToMainButton:SetScript("OnClick", function(self, button, down)
    MainFrame:Show()
    SettingsFrame:Hide()
end)

-- mainFrame interactions

-- mainFrame:Hide();
SettingsFrame:EnableMouse(true);
SettingsFrame:SetMovable(true);
SettingsFrame:RegisterForDrag("LeftButton");
SettingsFrame:SetScript("OnDragStart", function(self)
    self:StartMoving();
end);
SettingsFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing();
end);

local checkboxes = 0





SLASH_EMHSettings1 = "/emhsettings";
SlashCmdList.EMHSettings = function()
    if SettingsFrame:IsShown() then
        SettingsFrame:Hide();
    else
        SettingsFrame:Show();
    end;
end;

local secondColumn = 0

local function CreateCheckbox(checkboxText, key, checkboxTooltip)
    local checkbox = CreateFrame("CheckButton", "MyAddonCheckboxID" .. checkboxes, SettingsFrame, "UICheckButtonTemplate")
    checkbox.Text:SetText(checkboxText)
    checkbox:SetPoint("TOPLEFT", SettingsFrame.subTitleNote, "TOPLEFT", (10 + secondColumn), -30 + (checkboxes * -30))


    if EMHDB.settingsKeys[key] == nil then
        EMHDB.settingsKeys[key] = true
        AddByName(key)
    end

    checkbox:SetChecked(EMHDB.settingsKeys[key])

    checkbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(checkboxTooltip, nil, nil, nil, nil, true)
    end)

    checkbox:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    checkbox:SetScript("OnClick", function(self)
        EMHDB.settingsKeys[key] = self:GetChecked()
        if (EMHDB.settingsKeys[key]) then
            AddByName(key)
            EMHDB.to_repair = EMHDB.to_repair + 1
        else
            RemoveByName(key)
            EMHDB.to_repair = EMHDB.to_repair - 1
        end
    end)

    checkboxes = checkboxes + 1
    if (checkboxes == 6) then
        secondColumn = 100
        checkboxes = 0
    end

    return checkbox
end

local eventListenerFrame = CreateFrame("Frame", "MyAddonSettingsEventListenerFrame", UIParent)

eventListenerFrame:RegisterEvent("PLAYER_LOGIN")

eventListenerFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        if not EMHDB.settingsKeys then
            EMHDB.settingsKeys = {}
        end

        if not EMHDB.to_repair then
            EMHDB.to_repair = 0
        end

        if not EMHDB.keys then
            EMHDB.keys = {}
        end

        for _, setting in pairs(settings) do
            CreateCheckbox(setting.settingText, setting.settingKey, setting.settingTooltip)
        end

        EMHDB.to_repair = #EMHDB.keys
    end
end)

table.insert(UISpecialFrames, "MyAddonMainFrame");

SettingsFrame:Hide();
