--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------------- Creation and initialization of the settings frame ----------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables
--------------------------------------------------------------------------------

local _, L = ...                      -- Localization
local _, addonTable = ...             -- Addon table
local checkboxes, secondColumn = 0, 0 -- Variables to place the checkboxes

local NAME_TO_ID = {
    head = 1,
    shoulder = 3,
    chest = 5,
    waist = 6,
    legs = 7,
    feet = 8,
    wrist = 9,
    hands = 10,
    mainHand = 16,
    offHand = 17,
    ranged = 18,
}

--------------------------------------------------------------------------------
--- Functions
--------------------------------------------------------------------------------
---
------ EMHDB.keys functions

--[[
Remove an item from EMHDB.keys by its name.
]]
local function removeByName(name)
    local id = NAME_TO_ID[name]

    if not id then
        print(string.format(L["ERROR_NO_NAME_IN_EMHDB"], name))
        return
    end

    for i = #EMHDB.keys, 1, -1 do
        if EMHDB.keys[i] == id then
            table.remove(EMHDB.keys, i)
            return
        end
    end
    -- Should not print
    error(string.format(L["ERROR_REMOVE_EMHDB"], id))
end

--[[
Add an item to EMHDB.keys by its name.
]]
local function addByName(name)
    local id = NAME_TO_ID[name]

    if not id then
        print(string.format(L["ERROR_NO_NAME_IN_EMHDB"], name))
        return
    end

    for _, v in ipairs(EMHDB.keys) do
        -- Should not print
        if v == id then
            error(string.format(L["ERROR_ADD_EMHDB"], id))
            return
        end
    end

    table.insert(EMHDB.keys, id)
end

--[[
Create a checkbox with the given text, key and tooltip, and add it to the addonTable.settingsFrame.
]]
function EMH_CreateCheckbox(checkboxText, key, checkboxTooltip)
    local checkbox = CreateFrame("CheckButton", "EMHCheckboxID" .. checkboxes, addonTable.settingsFrame,
        "UICheckButtonTemplate")
    checkbox.Text:SetText(" - " .. checkboxText)
    checkbox:SetPoint("TOP", addonTable.settingsFrame.subTitleNote1, "TOP", (-135 + secondColumn),
        -50 + (checkboxes * -30))

    if EMHDB.settingsKeys[key] == nil then
        EMHDB.settingsKeys[key] = true
        addByName(key)
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
            addByName(key)
            EMHDB.to_repair = EMHDB.to_repair + 1
        else
            removeByName(key)
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
-------------------------- Create the addonTable.settingsFrame ----------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Settings Frame
--------------------------------------------------------------------------------

addonTable.settingsFrame = CreateFrame("Frame", "EMHSettingsFrame", UIParent, "BasicFrameTemplateWithInset")

addonTable.settingsFrame:SetSize(addonTable.FRAMES_WIDTH, addonTable.FRAMES_HEIGHT)
addonTable.settingsFrame:SetFrameStrata("DIALOG")
EMH_SetFramePosition(addonTable.settingsFrame)
addonTable.settingsFrame:Hide()
addonTable.settingsFrame.TitleBg:SetHeight(30)
addonTable.settingsFrame.title = addonTable.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
addonTable.settingsFrame.title:SetPoint("TOPLEFT", addonTable.settingsFrame.TitleBg, "TOPLEFT", 5, -3)
addonTable.settingsFrame.title:SetText(L["SETTINGS_FRAME_TITLE"])

addonTable.settingsFrame.subTitle = addonTable.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
local font, _, flags = addonTable.settingsFrame.subTitle:GetFont()
if font then
    addonTable.settingsFrame.subTitle:SetFont(font, 16, flags)
end
addonTable.settingsFrame.subTitle:SetPoint("TOPLEFT", addonTable.settingsFrame, "TOPLEFT", 15, -35)
addonTable.settingsFrame.subTitle:SetText(L["SETTINGS_SUB_TITLE"])
addonTable.settingsFrame.subTitleNote1 = addonTable.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addonTable.settingsFrame.subTitleNote1:SetPoint("TOPLEFT", addonTable.settingsFrame.subTitle, "BOTTOMLEFT", 0, -12)
addonTable.settingsFrame.subTitleNote1:SetText(L["SETTINGS_SUB_TITLE_NOTE_1"])
addonTable.settingsFrame.subTitleNote2 = addonTable.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addonTable.settingsFrame.subTitleNote2:SetPoint("TOPLEFT", addonTable.settingsFrame.subTitleNote1, "BOTTOMLEFT", 0, -8)
addonTable.settingsFrame.subTitleNote2:SetText(L["SETTINGS_SUB_TITLE_NOTE_2"])

-- Button "Go to Main Frame"

local goToMainButton = CreateFrame("Button", "goToMainButton", addonTable.settingsFrame, "UIPanelButtonTemplate")
goToMainButton:SetPoint("TOPRIGHT", addonTable.settingsFrame, "TOPRIGHT", -25, 0)
goToMainButton:SetSize(160, 20)
goToMainButton:SetText(L["SETTINGS_TO_MAIN_BUTTON"])
goToMainButton:SetScript("OnClick", function(self)
    EMH_FrameToggle()
end)

-- Settings frame interactions

-- Make the frame movable
addonTable.settingsFrame:EnableMouse(true)
addonTable.settingsFrame:SetMovable(true)
addonTable.settingsFrame:RegisterForDrag("LeftButton")
addonTable.settingsFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
addonTable.settingsFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    EMH_SaveFramePosition(addonTable.settingsFrame)
end)

-- Reset the position of the frame when right-clicking on it
addonTable.settingsFrame:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
        EMH_DefaultFramePosition(addonTable.settingsFrame)
    end
end)

-- Update position when opening the frame
addonTable.settingsFrame:SetScript("OnShow", function()
    EMH_SetFramePosition(addonTable.settingsFrame)
end)

-- Save position when closing the frame
addonTable.settingsFrame:SetScript("OnHide", function()
    EMH_SaveFramePosition(addonTable.settingsFrame)
end)

-- Allow escap key to close the frame

table.insert(UISpecialFrames, "EMHSettingsFrame")
