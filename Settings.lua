--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------------- Creation and initialization of the settings frame ----------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables
--------------------------------------------------------------------------------

local _, L = ...          -- Localization
local _, addonTable = ... -- Addon table

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

-- Capability display: two columns anchored below subTitleNote1.
-- FontStrings are created once here; text is refreshed each time the frame opens.
local CAP_ROW_HEIGHT                    = 16
local CAP_COL_RIGHT_X                   = 225
local CAP_TOP_Y                         = -20 -- offset below subTitleNote1

addonTable.settingsFrame.capArmorHeader = addonTable.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
local font, _, flags                    = addonTable.settingsFrame.capArmorHeader:GetFont()
if font then
    addonTable.settingsFrame.capArmorHeader:SetFont(font, 16, flags)
end
addonTable.settingsFrame.capArmorHeader:SetPoint("TOPLEFT", addonTable.settingsFrame.subTitleNote1, "BOTTOMLEFT",
    0, CAP_TOP_Y)

addonTable.settingsFrame.capWeaponsHeader = addonTable.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
local font2, _, flags2 = addonTable.settingsFrame.capWeaponsHeader:GetFont()
if font2 then
    addonTable.settingsFrame.capWeaponsHeader:SetFont(font2, 16, flags2)
end
addonTable.settingsFrame.capWeaponsHeader:SetPoint("TOPLEFT", addonTable.settingsFrame.subTitleNote1, "BOTTOMLEFT",
    CAP_COL_RIGHT_X, CAP_TOP_Y)

addonTable.settingsFrame.armorEntries  = {}
addonTable.settingsFrame.weaponEntries = {}

for i, slotID in ipairs(addonTable.ARMOR_SLOTS_ORDER) do
    local fs = addonTable.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("TOPLEFT", addonTable.settingsFrame.subTitleNote1, "BOTTOMLEFT",
        10, CAP_TOP_Y - CAP_ROW_HEIGHT * i)
    addonTable.settingsFrame.armorEntries[slotID] = fs
end

for i, cat in ipairs(addonTable.WEAPON_CATS_ORDER) do
    local fs = addonTable.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("TOPLEFT", addonTable.settingsFrame.subTitleNote1, "BOTTOMLEFT",
        CAP_COL_RIGHT_X + 10, CAP_TOP_Y - CAP_ROW_HEIGHT * i)
    addonTable.settingsFrame.weaponEntries[cat] = fs
end

-- Refresh the capability display text. Called each time the settings frame opens.
local function refreshCapabilityDisplay()
    addonTable.settingsFrame.capArmorHeader:SetText(L["CAP_ARMOR"])
    addonTable.settingsFrame.capWeaponsHeader:SetText(L["CAP_WEAPONS"])

    local armorCap, weaponCap = EMH_GetCapabilities()
    local hasTWW              = EMH_HasHammerInBags(addonTable.HAMMER_ID_TWW)
    local hasMidnight         = EMH_HasHammerInBags(addonTable.HAMMER_ID_MIDNIGHT)

    -- Returns a colored label string for one source (TWW or MN).
    -- hasNode   : whether the talent node for this source is unlocked for the slot
    -- hasHammer : whether this source's hammer is in bags
    local function coloredLabel(labelStr, hasNode, hasHammer)
        local color
        if hasNode and hasHammer then
            color = "|cff00ff00" -- green
        elseif hasNode or hasHammer then
            color = "|cffffff00" -- yellow
        else
            color = "|cffff4444" -- red
        end
        return color .. labelStr .. "|r"
    end

    -- Builds "Label: TWW_colored / MN_colored" for a given cap entry.
    local function buildEntryText(label, cap)
        local hasTWWNode = cap ~= nil and cap.source == "tww"
        local hasMNNode  = cap ~= nil and cap.source == "midnight"
        local twwStr     = coloredLabel(L["CAP_SOURCE_TWW"], hasTWWNode, hasTWW)
        local mnStr      = coloredLabel(L["CAP_SOURCE_MIDNIGHT"], hasMNNode, hasMidnight)
        return label .. ": " .. twwStr .. " / " .. mnStr
    end

    for _, slotID in ipairs(addonTable.ARMOR_SLOTS_ORDER) do
        local text = buildEntryText(L[addonTable.ID_TO_NAME[slotID]], armorCap[slotID])
        addonTable.settingsFrame.armorEntries[slotID]:SetText(text)
    end

    for _, cat in ipairs(addonTable.WEAPON_CATS_ORDER) do
        local text = buildEntryText(L[addonTable.CATEGORY_TO_NAME[cat]], weaponCap[cat])
        addonTable.settingsFrame.weaponEntries[cat]:SetText(text)
    end
end

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

-- Update position and refresh capability display when opening the frame
addonTable.settingsFrame:SetScript("OnShow", function()
    EMH_SetFramePosition(addonTable.settingsFrame)
    refreshCapabilityDisplay()
end)

-- Save position when closing the frame
addonTable.settingsFrame:SetScript("OnHide", function()
    EMH_SaveFramePosition(addonTable.settingsFrame)
end)

-- Allow escap key to close the frame
table.insert(UISpecialFrames, "EMHSettingsFrame")
