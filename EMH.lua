--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------- Initialization of the addon, the database and the settings ----------
--------------------------------------------------------------------------------
--- Function and variables needed at initialization
--------------------------------------------------------------------------------

local repairOpen = false              -- True if the frame of a merchant who can repair is open
local checkboxes, secondColumn = 0, 0 -- Variables to place the checkboxes
local RIGHT_OF_MERCHANT_FRAME = 298   -- Position of the MainFrame relative to the MerchantFrame


--[[
Check if the player needs to repair his items

@return true if the player needs to repair his items, false otherwise
]]
local function checkRepairNeeded()
    local repairCost, _ = GetRepairAllCost()
    if repairCost > 0 then
        return true
    end
    return false
end

--[[
Open the EMH frame (to the right of the merchant frame) if:
- the merchant can repair
- the player needs to repair his items
]]
local function openEMHMerchant()
    if (CanMerchantRepair() and checkRepairNeeded()) then
        repairOpen = true
        SettingsFrame:Hide()

        -- Set the position of the MainFrame
        MainFrame:ClearAllPoints()
        MainFrame:SetPoint("TOP", MerchantFrame, "TOPRIGHT", RIGHT_OF_MERCHANT_FRAME, 0)
        MainFrame:Show()
    end
end

--[[
Close the EMH frame if the merchant frame that was opened could repair
]]
local function closeEMHMerchant()
    if (repairOpen) then
        repairOpen = false
        MainFrame:Hide()
        SettingsFrame:Hide()
    end
end


--- Initialize checkbox

--[[
Create a checkbox with the given text, key and tooltip, and add it to the SettingsFrame.
]]
local function createCheckbox(checkboxText, key, checkboxTooltip)
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


--------------------------------------------------------------------------------
--- Initialization
--------------------------------------------------------------------------------

-- Initialize the database and the settings
local eventListenerFrame = CreateFrame("Frame", "EMHSettingsEventListenerFrame", UIParent)

eventListenerFrame:RegisterEvent("PLAYER_LOGIN")
eventListenerFrame:RegisterEvent("MERCHANT_SHOW")
eventListenerFrame:RegisterEvent("MERCHANT_CLOSED")

eventListenerFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        CheckProfession()
        if not EMHDB then
            EMHDB = {}
        end
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

        if not EMHDB.framePos then
            EMHDB.framePos = {}
            SaveFramePosition(MainFrame) -- Initializing the frame position
        end

        for _, setting in pairs(SETTINGS) do
            createCheckbox(setting.settingText, setting.settingKey, setting.settingTooltip)
        end

        EMHDB.to_repair = #EMHDB.keys
    elseif (event == "MERCHANT_SHOW" and not BadProfession) then
        openEMHMerchant()
    elseif (event == "MERCHANT_CLOSED" and not BadProfession) then
        closeEMHMerchant()
    end
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- Variables and misceallenous functions ---------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Local variables and constants
--------------------------------------------------------------------------------

local itemName, repairAllCost, currentRepairCost, current, maximum
local testTicker = {}

--------------------------------------------------------------------------------
--- Miscellaneous functions
--------------------------------------------------------------------------------

-- Format money in gold, silver and copper: 155425 -> "15 gold, 54 silver, 25 copper"
local function formatMoney(copper)
    if copper == 0 then
        return string.format(L["FORMAT_MONEY"], 0, 0, 0)
    end
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copper = copper % 100
    return string.format(L["FORMAT_MONEY"], gold, silver, copper)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------- Create the MainFrame ------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Main Frame
--------------------------------------------------------------------------------

-- Create the main frame

MainFrame = CreateFrame("Frame", "EMHMainFrame", UIParent, "BasicFrameTemplateWithInset");

MainFrame:SetSize(520, 320);
MainFrame:SetFrameStrata("DIALOG");
SetFramePosition(MainFrame);
MainFrame.TitleBg:SetHeight(30);
MainFrame.title = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
MainFrame.title:SetPoint("TOPLEFT", MainFrame.TitleBg, "TOPLEFT", 5, -3);
MainFrame.title:SetText(L["MAIN_FRAME_TITLE"]);

MainFrame.subTitle1 = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
MainFrame.subTitle1:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 15, -35);
MainFrame.subTitle1:SetText(L["SUB_TITLE"]);
MainFrame.goldSaved = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
MainFrame.goldSaved:SetPoint("TOP", MainFrame.subTitle1, "BOTTOM", 30, -15);

-- Tooltip gold

local tooltipButton = CreateFrame("Button", nil, MainFrame, "UIPanelButtonTemplate")
tooltipButton:SetSize(24, 24)
tooltipButton:SetPoint("TOPRIGHT", MainFrame.subTitle1, "TOPRIGHT", 50, 5)

-- Create a font string for the "?"
local fontString = tooltipButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
fontString:SetPoint("CENTER", tooltipButton, "CENTER", 0, 0)
fontString:SetText("?")


-- Button "Go to settings frame"

local goToSettingsButton = CreateFrame("Button", "goToSettingsButton", MainFrame, "UIPanelButtonTemplate")
goToSettingsButton:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -25, 0)
goToSettingsButton:SetSize(150, 20)
goToSettingsButton:SetText(L["MAIN_TO_SETTINGS_BUTTON"])

goToSettingsButton:SetScript("OnClick", function(self, button, down)
    SaveFramePosition(MainFrame)
    MainFrame:Hide()
    SetFramePosition(SettingsFrame)
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
    SaveFramePosition(MainFrame)
end);

-- Add tooltip to the button

tooltipButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(L["GOLD_TOOLTIP"], nil, nil, nil, nil, true)
    GameTooltip:Show()
end)

tooltipButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Allow escap key to close the frame

table.insert(UISpecialFrames, "EMHMainFrame");

--------------------------------------------------------------------------------
--- Button to repair the items
--------------------------------------------------------------------------------

local useItemButton = CreateFrame("Button", "UseItemButton", MainFrame,
    "SecureActionButtonTemplate, UIPanelButtonTemplate")
useItemButton:SetPoint("CENTER", MainFrame, 0, 0)
useItemButton:SetSize(280, 40)
useItemButton:SetText(L["LOADING"])
useItemButton:RegisterForClicks("AnyUp", "AnyDown")
useItemButton:SetAttribute("type1", "macro")

--------------------------------------------------------------------------------
--- Button repair's functions
--------------------------------------------------------------------------------

--[[
Check the durability of the items and update the button if a repair is needed
Start the ticker to check durability every second until the item is repaired

@param i: the index of the item to check
@return true if the item has full durability or isn't checked in the settings, false otherwise
]]
local function performTest(i)
    current, maximum = GetInventoryItemDurability(EMHDB.keys[i])
    if current and maximum then
        if current < maximum then
            -- Update the repair button and wait for the users to click on it
            useItemButton:SetText(string.format(L["REPAIR_BUTTON"], L[ID_TO_NAME[EMHDB.keys[i]]], i, EMHDB.to_repair))
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

--[[
Once the repairs are finished, update the button, the gold saved and print a message
to tell the user how much gold he saved
]]
local function endRepairs()
    useItemButton:SetText(L["NO_REPAIR"])
    currentRepairCost, _ = GetRepairAllCost()

    local gold_saved = repairAllCost - currentRepairCost
    EMHDB.goldSaved = EMHDB.goldSaved + gold_saved
    MainFrame.goldSaved:SetText(formatMoney(EMHDB.goldSaved))
    if (gold_saved > 0) then
        print(string.format(L["SAVED_MONEY_PRINT"], formatMoney(gold_saved)))
    end
end

--[[
Start the ticker to check durability every {TICKER} seconds until all the items are repaired,
then stop the ticker and update the button
]]
local function startTicker(i)
    testTicker = C_Timer.NewTicker(TICKER, function()
        local continue = performTest(i)
        if continue then
            i = i + 1
            if i > #EMHDB.keys then
                endRepairs()
                testTicker:Cancel()
                testTicker = nil
            end
        end
    end)
end


--[[
Run all tests instantly to check if any items need to be repaired
If a repair is needed, start the ticker to check durability every second until the item is repaired
]] --

local function runTestsInstantly(i)
    repairAllCost, _ = GetRepairAllCost()
    while i <= #EMHDB.keys do
        local continue = performTest(i)
        if not continue then
            -- If a repair is needed, start the ticker
            startTicker(i)
            return
        end
        i = i + 1
    end
    -- If no repair is needed, call the end function
    endRepairs()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------- Scripts and command -------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Scripts
--------------------------------------------------------------------------------

-- When the Main Frame is shown, run the tests
MainFrame:SetScript("OnShow", function()
    runTestsInstantly(1)
end)

-- When the Main Frame is hidden, stop the tests
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
    -- Check if the player has the right profession: Blacksmithing
    if BadProfession then
        return
    end

    -- Check if the player has the hammer in his inventory
    itemName, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _ =
        C_Item.GetItemInfo(HAMMER_ID)

    if not itemName then
        print(L["NO_EMH"])
        return
    end

    -- Hide both frames and save the position of the Main Frame
    if MainFrame:IsShown() then
        SaveFramePosition(MainFrame)
        MainFrame:Hide();
        SettingsFrame:Hide();
        -- Set the Main Frame position, update the gold saved, show the Main Frame and hide the Settings Frame
    elseif not MainFrame:IsShown() then
        MainFrame.goldSaved:SetText(formatMoney(EMHDB.goldSaved))
        SetFramePosition(MainFrame)
        SettingsFrame:Hide();
        MainFrame:Show();
    end
end;

--------------------------------------------------------------------------------
--- Everything is working
--------------------------------------------------------------------------------

print("EMH - end.")
