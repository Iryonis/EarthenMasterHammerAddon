print("EMH loaded.")

if EMHDB == nil then
    EMHDB = {}
end

local convertIdToName = {
    [1] = "Tête",
    [3] = "Épaule",
    [5] = "Torse",
    [6] = "Taille",
    [7] = "Jambes",
    [8] = "Pieds",
    [9] = "Poignets",
    [10] = "Mains",
    [16] = "Main droite",
    [17] = "Main gauche",
    [18] = "À distance",
}

local current, maximum

for key, value in pairs(convertIdToName) do
    current, maximum = GetInventoryItemDurability(key)
    -- print("Slot " .. value .. ": " .. (current or '0') .. "/" .. (maximum or '0'))
end

local mainFrame = CreateFrame("Frame", "EMHMainFrame", UIParent, "BasicFrameTemplateWithInset");

mainFrame:SetSize(500, 350);
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
mainFrame.TitleBg:SetHeight(30);
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
mainFrame.title:SetPoint("TOPLEFT", mainFrame.TitleBg, "TOPLEFT", 5, -3);
mainFrame.title:SetText("Earthen Masters's Hammer - Settings");

-- local MacroButton = CreateFrame("Button", "MyMacroButton", UIParent, "SecureActionButtonTemplate");
-- MacroButton:RegisterForClicks("AnyUp");                              --   Respond to all buttons
-- MacroButton:SetAttribute("type", "macro");                           -- Set type to "macro"
-- MacroButton:SetAttribute("macrotext", "/say Using my Hearthstone."); -- Set our macro text
-- SetBindingClick("ALT-CTRL-F", "MyMacroButton", "MyMacroButton");
local btn = CreateFrame("Button", "test", mainFrame, "UIPanelButtonTemplate")
btn:SetPoint("CENTER")
btn:SetSize(100, 40)
btn:SetText("Click me")
btn:SetScript("OnClick", function(self, button, down)
    -- print("Pressed", button, down and "down" or "up")
    local itemInfo = C_Container.GetContainerItemInfo(2, 8)
    if itemInfo then
        print("Using item: " .. itemInfo.hyperlink .. " et id: " .. itemInfo.itemID)
    else
        print("No item in slot 1, 1")
    end
end)
SetBindingClick("R", "test", "test");
btn:RegisterForClicks("AnyDown", "AnyUp")

local useItemButton = CreateFrame("Button", "UseItemButton", mainFrame, "SecureActionButtonTemplate")
useItemButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 10)
useItemButton:SetSize(120, 40)
useItemButton:SetText("Use Item")
useItemButton:SetNormalFontObject("GameFontNormal")
useItemButton:SetHighlightFontObject("GameFontHighlight")

local ntex = useItemButton:CreateTexture()
ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
ntex:SetTexCoord(0, 0.625, 0, 0.6875)
ntex:SetAllPoints()
useItemButton:SetNormalTexture(ntex)

local htex = useItemButton:CreateTexture()
htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
htex:SetTexCoord(0, 0.625, 0, 0.6875)
htex:SetAllPoints()
useItemButton:SetHighlightTexture(htex)

local ptex = useItemButton:CreateTexture()
ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
ptex:SetTexCoord(0, 0.625, 0, 0.6875)
ptex:SetAllPoints()
useItemButton:SetPushedTexture(ptex)

useItemButton:RegisterForClicks("AnyUp")
useItemButton:SetAttribute("type", "macro"); -- Set type to "macro"
useItemButton:SetAttribute("macrotext", "/use Boule de neige");

-- mainFrame interactions

-- mainFrame:Hide();
mainFrame:EnableMouse(true);
mainFrame:SetMovable(true);
mainFrame:RegisterForDrag("LeftButton");
mainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving();
end);
mainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing();
end);
mainFrame:SetScript("OnShow", function()
    PlaySound(808);
end);
mainFrame:SetScript("OnHide", function()
    PlaySound(808);
end);


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
        settingKey = "wrist",
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

local checkboxes = 0


local function CreateCheckbox(checkboxText, key, checkboxTooltip)
    local checkbox = CreateFrame("CheckButton", "MyAddonCheckboxID" .. checkboxes, mainFrame, "UICheckButtonTemplate")
    checkbox.Text:SetText(checkboxText)
    checkbox:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 10, -30 + (checkboxes * -30))

    if EMHDB.settingsKeys[key] == nil then
        EMHDB.settingsKeys[key] = true
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
    end)

    checkboxes = checkboxes + 1

    return checkbox
end

local eventListenerFrame = CreateFrame("Frame", "MyAddonSettingsEventListenerFrame", UIParent)

eventListenerFrame:RegisterEvent("PLAYER_LOGIN")

eventListenerFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        if not EMHDB.settingsKeys then
            EMHDB.settingsKeys = {}
        end

        for _, setting in pairs(settings) do
            CreateCheckbox(setting.settingText, setting.settingKey, setting.settingTooltip)
        end
    end
end)


SLASH_EMH1 = "/emh";
SlashCmdList.EMH = function()
    if mainFrame:IsShown() then
        mainFrame:Hide();
    else
        mainFrame:Show();
    end;
end;

table.insert(UISpecialFrames, "MyAddonMainFrame");
