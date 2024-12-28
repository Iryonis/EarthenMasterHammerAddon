print("EMH loaded.")

if not EMHDB then
    EMHDB = {}
end

local idToName = {
    [1] = "head",
    [3] = "shoulder",
    [5] = "chest",
    [6] = "waist",
    [7] = "legs",
    [8] = "feet",
    [9] = "wrists",
    [10] = "hands",
    [16] = "mainHand",
    [17] = "offHand",
    [18] = "ranged",
}


local keysSave = {}

local hammerId = 225660

local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID, isCraftingReagent =
    C_Item.GetItemInfo(hammerId)


MainFrame = CreateFrame("Frame", "MyAddonMainFrame", UIParent, "BasicFrameTemplateWithInset");

MainFrame:SetSize(500, 350);
MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
MainFrame.TitleBg:SetHeight(30);
MainFrame.title = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
MainFrame.title:SetPoint("TOPLEFT", MainFrame.TitleBg, "TOPLEFT", 5, -3);
MainFrame.title:SetText("Earthen Masters's Hammer");
MainFrame.subTitle1 = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
MainFrame.subTitle1:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 15, -35);
MainFrame.subTitle1:SetText(
    "By repairing your gear with Earthen Masters's Hammer,");
MainFrame.subTitle2 = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
MainFrame.subTitle2:SetPoint("TOPLEFT", MainFrame.subTitle1, "TOPLEFT", 0, -10);
MainFrame.subTitle2:SetText(
    "and since the download of this addon, you have saved:");
MainFrame.goldSaved = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
MainFrame.goldSaved:SetPoint("TOPLEFT", MainFrame.subTitle2, "BOTTOMLEFT", 0, -15);
MainFrame.goldSaved:SetText(
    " gold");

-- Go to settings frame

local goToSettingsButton = CreateFrame("Button", "goToSettingsButton", MainFrame, "UIPanelButtonTemplate")
goToSettingsButton:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -25, 0)
goToSettingsButton:SetSize(150, 20)
goToSettingsButton:SetText("Switch to settings")
goToSettingsButton:SetScript("OnClick", function(self, button, down)
    MainFrame:Hide()
    SettingsFrame:Show()
end)
SetBindingClick("R", "test", "test");
goToSettingsButton:RegisterForClicks("AnyDown", "AnyUp")

MainFrame:EnableMouse(true);
MainFrame:SetMovable(true);
MainFrame:RegisterForDrag("LeftButton");
MainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving();
end);
MainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing();
end);

SLASH_EMH1 = "/emh";
SlashCmdList.EMH = function()
    if MainFrame:IsShown() then
        MainFrame:Hide();
    else
        MainFrame:Show();
    end;
end;

local useItemButton = CreateFrame("Button", "UseItemButton", MainFrame,
    "SecureActionButtonTemplate, UIPanelButtonTemplate")
useItemButton:SetPoint("CENTER", MainFrame, 0, 0)
useItemButton:SetSize(280, 40)
useItemButton:SetText("Loading...")
useItemButton:RegisterForClicks("AnyUp", "AnyDown")
useItemButton:SetAttribute("type1", "macro")


-- Fonction de test à exécuter
local function PerformTest(i)
    print("Test exécuté pour l'index: " .. i)
    local current, maximum
    current, maximum = GetInventoryItemDurability(EMHDB.keys[i])
    if current and maximum then
        if current < maximum then
            useItemButton:SetText("Réparer: " ..
                idToName[EMHDB.keys[i]] .. " (" .. i .. "/" .. EMHDB.to_repair .. ")")
            useItemButton:SetAttribute("macrotext", "/use Marteau de maître terrestre\n/use " .. EMHDB.keys[i])
            -- Indiquer à l'utilisateur que la réparation est nécessaire
            -- Continuer à vérifier cette pièce toutes les secondes jusqu'à ce qu'elle soit réparée
            return false
        else
            -- Passer à la pièce suivante
            return true
        end
    else
        -- Si la pièce n'a pas besoin de réparation ou n'est pas configurée pour être vérifiée
        return true
    end
end

-- Initialiser le ticker
local testTicker = {}

-- Fonction pour démarrer le ticker
local function StartTicker(i)
    testTicker = C_Timer.NewTicker(1, function()
        local continue = PerformTest(i)
        if continue then
            i = i + 1
            if i > #EMHDB.keys then
                useItemButton:SetText("Aucune réparation nécessaire")
                testTicker:Cancel()
                testTicker = nil
            end
        end
    end)
end

-- Fonction pour exécuter les tests instantanément
local function RunTestsInstantly(i)
    while i <= #EMHDB.keys do
        local continue = PerformTest(i)
        if not continue then
            -- Si une réparation est nécessaire, démarrer le ticker
            StartTicker(i)
            return
        end
        i = i + 1
    end
    useItemButton:SetText("Aucune réparation nécessaire")
end

MainFrame:SetScript("OnShow", function()
    local i = 1
    RunTestsInstantly(i)
end)

MainFrame:SetScript("OnHide", function()
    if testTicker then
        testTicker:Cancel()
        testTicker = nil
    end
end)

print("Addon chargé")
