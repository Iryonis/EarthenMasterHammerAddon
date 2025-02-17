--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------------- Create the checkboxes ----------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables
--------------------------------------------------------------------------------

local checkboxes, secondColumn = 0, 0 -- Variables to place the checkboxes

--------------------------------------------------------------------------------
--- Functions
--------------------------------------------------------------------------------

--[[
Create a checkbox with the given text, key and tooltip, and add it to the SettingsFrame.
]]
function CreateCheckbox(checkboxText, key, checkboxTooltip)
    local checkbox = CreateFrame("CheckButton", "EMHCheckboxID" .. checkboxes, SettingsFrame, "UICheckButtonTemplate")
    checkbox.Text:SetText(" - " .. checkboxText)
    checkbox:SetPoint("TOP", SettingsFrame.subTitleNote2, "TOP", (-20 + secondColumn), -30 + (checkboxes * -30))


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
    if (checkboxes == 5) then
        secondColumn = 200
        checkboxes = 0
    end

    return checkbox
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------------- Create the SettingsFrame ----------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Settings Frame
--------------------------------------------------------------------------------

SettingsFrame = CreateFrame("Frame", "EMHSettingsFrame", UIParent, "BasicFrameTemplateWithInset");

SettingsFrame:SetSize(FRAMES_WIDTH, FRAMES_HEIGHT);
SettingsFrame:SetFrameStrata("DIALOG")
SetFramePosition(SettingsFrame);
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

-- Button "Go to Main Frame"

local goToMainButton = CreateFrame("Button", "goToMainButton", SettingsFrame, "UIPanelButtonTemplate")
goToMainButton:SetPoint("TOPRIGHT", SettingsFrame, "TOPRIGHT", -25, 0)
goToMainButton:SetSize(160, 20)
goToMainButton:SetText(L["SETTINGS_TO_MAIN_BUTTON"])
goToMainButton:SetScript("OnClick", function(self, button, down)
    SaveFramePosition(SettingsFrame)
    SettingsFrame:Hide()
    SetFramePosition(MainFrame)
    MainFrame:Show()
end)

-- Settings frame interactions

SettingsFrame:EnableMouse(true);
SettingsFrame:SetMovable(true);
SettingsFrame:RegisterForDrag("LeftButton");
SettingsFrame:SetScript("OnDragStart", function(self)
    self:StartMoving();
end);
SettingsFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing();
    SaveFramePosition(self);
end);

-- Allow escap key to close the frame

table.insert(UISpecialFrames, "EMHSettingsFrame");
