--------------------------------------------------------------------------------
--- Local variables
--------------------------------------------------------------------------------

local _, L = ...;

local settings = {
    {
        settingText = L["head"],
        settingKey = "head",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["head_node"]),
    },
    {
        settingText = L["shoulder"],
        settingKey = "shoulder",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["shoulder_node"]),
    },
    {
        settingText = L["chest"],
        settingKey = "chest",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["chest_node"]),
    },
    {
        settingText = L["waist"],
        settingKey = "waist",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["waist_node"]),
    },
    {
        settingText = L["legs"],
        settingKey = "legs",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["legs_node"]),
    },
    {
        settingText = L["feet"],
        settingKey = "feet",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["feet_node"]),
    },
    {
        settingText = L["wrists"],
        settingKey = "wrists",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["wrists_node"]),
    },
    {
        settingText = L["hands"],
        settingKey = "hands",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["hands_node"]),
    },
    {
        settingText = L["mainHand"],
        settingKey = "mainHand",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["mainHand_node"]),
    },
    {
        settingText = L["offHand"],
        settingKey = "offHand",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["offHand_node"]),
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

local checkboxes, secondColumn = 0, 0

--------------------------------------------------------------------------------
--- Miscellaneous functions
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
--- Main
--------------------------------------------------------------------------------

--- Create checkboxes for each settings and finish initialization


--- Create frame

SettingsFrame = CreateFrame("Frame", "EMHSettingsFrame", UIParent, "BasicFrameTemplateWithInset");

SettingsFrame:SetSize(520, 320);
SettingsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
SettingsFrame.TitleBg:SetHeight(30);
SettingsFrame.title = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
SettingsFrame.title:SetPoint("TOPLEFT", SettingsFrame.TitleBg, "TOPLEFT", 5, -3);
SettingsFrame.title:SetText(L["SETTINGS_FRAME_TITLE"]);

SettingsFrame.subTitle = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
local font, _, flags = SettingsFrame.subTitle:GetFont()
if font then
    SettingsFrame.subTitle:SetFont(font, 16, flags)
end
SettingsFrame.subTitle:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 15, -35);
SettingsFrame.subTitle:SetText(L["SETTINGS_SUB_TITLE"]);
SettingsFrame.subTitleNote1 = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
SettingsFrame.subTitleNote1:SetPoint("TOPLEFT", SettingsFrame.subTitle, "BOTTOMLEFT", 0, -12);
SettingsFrame.subTitleNote1:SetText(L["SETTINGS_SUB_TITLE_NOTE_1"]);
SettingsFrame.subTitleNote2 = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
SettingsFrame.subTitleNote2:SetPoint("TOPLEFT", SettingsFrame.subTitleNote1, "BOTTOMLEFT", 0, -8);
SettingsFrame.subTitleNote2:SetText(L["SETTINGS_SUB_TITLE_NOTE_2"]);

-- Button to go back to main frame
local goToMainButton = CreateFrame("Button", "goToMainButton", SettingsFrame, "UIPanelButtonTemplate")
goToMainButton:SetPoint("TOPRIGHT", SettingsFrame, "TOPRIGHT", -25, 0)
goToMainButton:SetSize(160, 20)
goToMainButton:SetText(L["SETTINGS_TO_MAIN_BUTTON"])
goToMainButton:SetScript("OnClick", function(self, button, down)
    MainFrame:Show()
    SettingsFrame:Hide()
end)

-- Settings frame interactions

-- SettingsFrame:Hide();
SettingsFrame:EnableMouse(true);
SettingsFrame:SetMovable(true);
SettingsFrame:RegisterForDrag("LeftButton");
SettingsFrame:SetScript("OnDragStart", function(self)
    self:StartMoving();
end);
SettingsFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing();
end);
-- Allow escap key to close the frame
table.insert(UISpecialFrames, "EMHSettingsFrame");

--------------------------------------------------------------------------------
--- Initialize data
--------------------------------------------------------------------------------

function CreateCheckbox(checkboxText, key, checkboxTooltip)
    local checkbox = CreateFrame("CheckButton", "EMHCheckboxID" .. checkboxes, SettingsFrame, "UICheckButtonTemplate")
    checkbox.Text:SetText(" - " .. checkboxText)
    checkbox:SetPoint("TOP", SettingsFrame.subTitleNote2, "TOP", (30 + secondColumn), -30 + (checkboxes * -30))


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
        secondColumn = 200
        checkboxes = 0
    end

    return checkbox
end

--- On login

local eventListenerFrame = CreateFrame("Frame", "EMHSettingsEventListenerFrame", UIParent)

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

        if not EMHDB.goldSaved then
            EMHDB.goldSaved = 0
        end

        for _, setting in pairs(settings) do
            CreateCheckbox(setting.settingText, setting.settingKey, setting.settingTooltip)
        end

        EMHDB.to_repair = #EMHDB.keys
    end
end)
