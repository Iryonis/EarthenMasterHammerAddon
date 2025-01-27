-- Active l'addon uniquement si le personnage a la profession de forge

-- Récupérer les professions du personnage
local prof1, prof2, _, _, _ = GetProfessions()

-- Fonction pour obtenir les informations de la profession
local function GetProfessionName(professionIndex)
    if professionIndex then
        local name, _, _, _, _, _, _, _, _, _ =
            GetProfessionInfo(professionIndex)
        return name
    end
    return "None"
end

-- Obtenir les noms des professions
local name1 = GetProfessionName(prof1)
local name2 = GetProfessionName(prof2)

if (name1 ~= "Forge" and name2 ~= "Forge") then -- vérifier blacksmithing
    return
end

print("EMH loaded.")



--------------------------------------------------------------------------------
--- Global variables
--------------------------------------------------------------------------------
if not EMHDB then
    EMHDB = {}
end

--------------------------------------------------------------------------------
--- Local variables
--------------------------------------------------------------------------------

local _, L = ...;
local hammerId = 225660 -- ID of the Earthen Master's Hammer
local itemName, repairAllCost, currentRepairCost, current, maximum
local testTicker = {}

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
}

--------------------------------------------------------------------------------
--- Miscellaneous functions
--------------------------------------------------------------------------------

local function FormatMoney(copper)
    if copper == 0 then
        return string.format(L["FORMAT_MONEY"], 0, 0, 0)
    end
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copper = copper % 100
    return string.format(L["FORMAT_MONEY"], gold, silver, copper)
end

--------------------------------------------------------------------------------
--- Main
--------------------------------------------------------------------------------

-- Create the main frame

MainFrame = CreateFrame("Frame", "EMHMainFrame", UIParent, "BasicFrameTemplateWithInset");

MainFrame:SetSize(520, 320);
MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
MainFrame.TitleBg:SetHeight(30);
MainFrame.title = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
MainFrame.title:SetPoint("TOPLEFT", MainFrame.TitleBg, "TOPLEFT", 5, -3);
MainFrame.title:SetText(L["MAIN_FRAME_TITLE"]);

MainFrame.subTitle1 = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
MainFrame.subTitle1:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 15, -35);
MainFrame.subTitle1:SetText(L["SUB_TITLE"]);
MainFrame.goldSaved = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
MainFrame.goldSaved:SetPoint("TOP", MainFrame.subTitle1, "BOTTOM", 30, -15);


-- Button "Go to settings frame"

local goToSettingsButton = CreateFrame("Button", "goToSettingsButton", MainFrame, "UIPanelButtonTemplate")
goToSettingsButton:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -25, 0)
goToSettingsButton:SetSize(150, 20)
goToSettingsButton:SetText(L["MAIN_TO_SETTINGS_BUTTON"])

goToSettingsButton:SetScript("OnClick", function(self, button, down)
    MainFrame:Hide()
    SettingsFrame:Show()
end)

-- Main frame interactions

MainFrame:EnableMouse(true);
MainFrame:SetMovable(true);
MainFrame:RegisterForDrag("LeftButton");
MainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving();
end);
MainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing();
end);
-- Allow escap key to close the frame
table.insert(UISpecialFrames, "EMHMainFrame");

-- Button "Repair equipment"

local useItemButton = CreateFrame("Button", "UseItemButton", MainFrame,
    "SecureActionButtonTemplate, UIPanelButtonTemplate")
useItemButton:SetPoint("CENTER", MainFrame, 0, 0)
useItemButton:SetSize(280, 40)
useItemButton:SetText(L["LOADING"])
useItemButton:RegisterForClicks("AnyUp", "AnyDown")
useItemButton:SetAttribute("type1", "macro")


-- Function to check the durability of the items
local function PerformTest(i)
    current, maximum = GetInventoryItemDurability(EMHDB.keys[i])
    if current and maximum then
        if current < maximum then
            -- Update the repair button and wait for the users to click on it
            useItemButton:SetText(string.format(L["REPAIR_BUTTON"], L[idToName[EMHDB.keys[i]]], i, EMHDB.to_repair))
            useItemButton:SetAttribute("macrotext", string.format(L["MACRO"], EMHDB.keys[i]))
            return false
        else
            -- Go to the next item
            return true
        end
    else
        -- If the item has full durability or isn't checked in the settings, go to the next item
        return true
    end
end

-- Function to update the variables and interface when the repairs are finished
local function EndRepairs()
    useItemButton:SetText(L["NO_REPAIR"])
    currentRepairCost, _ = GetRepairAllCost()

    local gold_saved = repairAllCost - currentRepairCost
    EMHDB.goldSaved = EMHDB.goldSaved + gold_saved
    MainFrame.goldSaved:SetText(FormatMoney(EMHDB.goldSaved))
    if (gold_saved > 0) then
        print(string.format(L["SAVED_MONEY_PRINT"], FormatMoney(gold_saved)))
    end
end

-- Fonction that starts the ticker to check durability every second
local function StartTicker(i)
    testTicker = C_Timer.NewTicker(0.1, function()
        local continue = PerformTest(i)
        if continue then
            i = i + 1
            if i > #EMHDB.keys then
                EndRepairs()
                testTicker:Cancel()
                testTicker = nil
            end
        end
    end)
end

-- Function that runs all tests instantly
-- If a repair is needed, start the ticker to check durability every second until the item is repaired
local function RunTestsInstantly(i)
    repairAllCost, _ = GetRepairAllCost()
    while i <= #EMHDB.keys do
        local continue = PerformTest(i)
        if not continue then
            -- If a repair is needed, start the ticker
            StartTicker(i)
            return
        end
        i = i + 1
    end
    -- If no repair is needed, update the button, the gold saved and print a message
    EndRepairs()
end

--- Main frame scripts - OnShow / OnHide
-- When the main frame is shown, run the tests
MainFrame:SetScript("OnShow", function()
    RunTestsInstantly(1)
end)

-- When the main frame is hidden, stop the tests
MainFrame:SetScript("OnHide", function()
    if testTicker then
        testTicker:Cancel()
        testTicker = nil
    end
end)

--------------------------------------------------------------------------------
--- Slash command
--------------------------------------------------------------------------------


SLASH_EMH1 = "/emh";
SlashCmdList.EMH = function()
    itemName, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _ =
        C_Item.GetItemInfo(hammerId)

    if not itemName then
        print(L["NO_EMH"])
        return
    end

    if MainFrame:IsShown() then
        MainFrame:Hide();
        SettingsFrame:Hide();
    else
        MainFrame.goldSaved:SetText(FormatMoney(EMHDB.goldSaved))
        MainFrame:Show();
        SettingsFrame:Hide();
    end;
end;

--------------------------------------------------------------------------------
--- Everything is working
--------------------------------------------------------------------------------

print("EMH - end.")
