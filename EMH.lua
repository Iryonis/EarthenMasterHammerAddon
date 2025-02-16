--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------- Initialization of the addon, the database and the settings ----------
--------------------------------------------------------------------------------
--- Function and variables needed at initialization
--------------------------------------------------------------------------------

local repairOpen = false            -- True if the frame of a merchant who can repair is open
local RIGHT_OF_MERCHANT_FRAME = 298 -- Position of the MainFrame relative to the MerchantFrame
local VERSION = "1.0.0"             -- Version of the addon

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
local function openEMHMerchant(frame)
    if (CanMerchantRepair() and checkRepairNeeded()) then
        repairOpen = true
        SettingsFrame:Hide()

        -- Set the position of the MainFrame
        frame:ClearAllPoints()
        frame:SetPoint("TOP", MerchantFrame, "TOPRIGHT", RIGHT_OF_MERCHANT_FRAME, 0)
        frame:Show()
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
            CreateCheckbox(setting.settingText, setting.settingKey, setting.settingTooltip)
        end
    elseif (event == "MERCHANT_SHOW" and not BadProfession) then
        openEMHMerchant(MainFrame)
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

local itemName, repairAllCost, currentRepairCost
local testTicker = {}

--------------------------------------------------------------------------------
--- Miscellaneous functions
--------------------------------------------------------------------------------
---

-- Format a number with commas: 155425 -> "155,425"
local function formatNumberWithCommas(number)
    local formatted = tostring(number)
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

-- Format money in gold, silver and copper: 155425 -> "15 gold, 54 silver, 25 copper"
local function formatMoney(money)
    if money == 0 then
        return string.format(L["FORMAT_MONEY"], 0, 0, 0)
    end
    local gold = math.floor(money / 10000)
    local silver = math.floor((money % 10000) / 100)
    local copper = money % 100
    -- Different format depending on language
    if GetLocale() == "enUS" then
        return string.format(L["FORMAT_MONEY"], formatNumberWithCommas(gold), silver, copper)
    else
        return string.format(L["FORMAT_MONEY"], gold, silver, copper)
    end
end

-- Check if the player has the hammer in his inventory
-- Only work the first time the player opens the MainFrame
local function checkHammerPresence(id)
    itemName, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _ =
        C_Item.GetItemInfo(id)

    if not itemName then
        print(L["NO_EMH"])
        return
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------- Create the MainFrame ------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Main Frame
--------------------------------------------------------------------------------

-- Create the main frame

MainFrame = CreateFrame("Frame", "EMHMainFrame", UIParent, "BasicFrameTemplateWithInset")

MainFrame:SetSize(FRAMES_WIDTH, FRAMES_HEIGHT)
MainFrame:SetFrameStrata("DIALOG")
SetFramePosition(MainFrame)
MainFrame.TitleBg:SetHeight(30)
MainFrame.title = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
MainFrame.title:SetPoint("TOPLEFT", MainFrame.TitleBg, "TOPLEFT", 5, -3)
MainFrame.title:SetText(L["MAIN_FRAME_TITLE"])

MainFrame.subTitle1 = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MainFrame.subTitle1:SetPoint("TOP", MainFrame, "TOP", 0, -35)
MainFrame.subTitle1:SetText(L["SUB_TITLE"])
MainFrame.goldSaved = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MainFrame.goldSaved:SetPoint("TOP", MainFrame.subTitle1, "BOTTOM", 0, -20)

-- Draw a horizontal line
MainFrame.backgroundButtonRepair = MainFrame:CreateTexture(nil, "ARTWORK")
MainFrame.backgroundButtonRepair:SetColorTexture(1, 1, 1, 0.05) -- Set the color to WoW yellow
MainFrame.backgroundButtonRepair:SetSize(480, 100)
MainFrame.backgroundButtonRepair:SetPoint("TOP", MainFrame.goldSaved, "BOTTOM", 0, -30)
-- Credits
MainFrame.credits = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MainFrame.credits:SetPoint("BOTTOM", MainFrame, "BOTTOM", 0, 15)
MainFrame.credits:SetText(string.format(L["CREDITS"], VERSION))

local horizontalLineCredits = MainFrame:CreateTexture(nil, "ARTWORK")
horizontalLineCredits:SetColorTexture(1, 0.82, 0, 1) -- Set the color to WoW yellow
horizontalLineCredits:SetSize(240, 1)
horizontalLineCredits:SetPoint("TOP", MainFrame.credits, "TOP", 0, 35)

-- Tooltip gold
local tooltipButton = CreateFrame("Button", nil, MainFrame, "UIPanelButtonTemplate")
tooltipButton:SetSize(24, 24)
tooltipButton:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -13, -30)
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
MainFrame:EnableMouse(true)
MainFrame:SetMovable(true)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
MainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    SaveFramePosition(MainFrame)
end)

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
table.insert(UISpecialFrames, "EMHMainFrame")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----------------------------- Button repair ------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Button to repair items
--------------------------------------------------------------------------------

local useItemButton = CreateFrame("Button", "UseItemButton", MainFrame,
    "SecureActionButtonTemplate, UIPanelButtonTemplate")
useItemButton:SetPoint("CENTER", MainFrame, "CENTER", 0, -10)
useItemButton:SetSize(280, 40)
useItemButton:SetText(L["LOADING"])
useItemButton:RegisterForClicks("AnyUp", "AnyDown")
useItemButton:SetAttribute("type1", "macro")

--------------------------------------------------------------------------------
--- Button repair's functions
--------------------------------------------------------------------------------

-- Check the durability of all the items and update EMHDB.to_repair in consequence
local function performAllTests()
    EMHDB.to_repair = 0
    for _, key in ipairs(EMHDB.keys) do
        local current, maximum = GetInventoryItemDurability(key)
        if current and maximum and current < maximum then
            EMHDB.to_repair = EMHDB.to_repair + 1
        end
    end
end

-- Check the durability of the given item

-- @param i: the index of the item to check
-- @return true if the item has full durability or isn't checked in the settings, false otherwise
local function performTest(i)
    local current, maximum = GetInventoryItemDurability(EMHDB.keys[i])
    if current and maximum and current < maximum then
        return false
    end
    return true
end

--[[
Check the durability of the items and update the button if a repair is needed

@param i: the index of the item to check
@param numero_item: the numero of the item which is being repaired
@return true if the item has full durability or isn't checked in the settings, false otherwise
]]
local function testAndUpdateButton(i, numero_item)
    if not performTest(i) then
        -- Update the repair button and wait for the users to click on it
        useItemButton:SetText(string.format(L["REPAIR_BUTTON"], L[ID_TO_NAME[EMHDB.keys[i]]], numero_item,
            EMHDB.to_repair))
        useItemButton:SetAttribute("macrotext", string.format(L["MACRO"], EMHDB.keys[i]))
        return false
    end
    -- Go to the next item
    return true
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

-- Function declared here to avoid a circular dependency
local waitForUserToRepair, runTestsInstantly

--[[
Wait for the user to repair the item then update i and numero_item, and run the tests again
Use a ticker to check the durability every {TICKER} seconds

@param i: the index of the item to check
@param numero_item: the numero of the item which is being repaired
]]
waitForUserToRepair = function(i, numero_item)
    if testAndUpdateButton(i, numero_item) then
        i = i + 1
        numero_item = numero_item + 1

        runTestsInstantly(i, numero_item)
    else
        C_Timer.After(TICKER, function() waitForUserToRepair(i, numero_item) end)
    end
end


--[[
Run all tests instantly to check if any items need to be repaired
If a repair is needed, start the ticker to check durability every second until the item is repaired

@param i: the index of the item to check
@param numero_item: the numero of the item which is being repaired
]]

runTestsInstantly = function(i, numero_item)
    while i <= #EMHDB.keys do
        if not performTest(i) then
            -- If a repair is needed, start the ticker
            waitForUserToRepair(i, numero_item)
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
    repairAllCost, _ = GetRepairAllCost()
    performAllTests()
    runTestsInstantly(1, 1)
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


SLASH_EMH1 = "/emh"
SlashCmdList.EMH = function()
    -- Check if the player has the right profession: Blacksmithing
    if BadProfession then
        return
    end

    -- Check if the player has the hammer in his inventory
    checkHammerPresence(HAMMER_ID)

    -- Hide both frames and save the position of the Main Frame
    if MainFrame:IsShown() then
        SaveFramePosition(MainFrame)
        MainFrame:Hide()
        SettingsFrame:Hide()
        -- Set the Main Frame position, update the gold saved, show the Main Frame and hide the Settings Frame
    elseif not MainFrame:IsShown() then
        MainFrame.goldSaved:SetText(formatMoney(EMHDB.goldSaved))
        SetFramePosition(MainFrame)
        SettingsFrame:Hide()
        MainFrame:Show()
    end
end

--------------------------------------------------------------------------------
--- Everything is working
--------------------------------------------------------------------------------

print("EMH - end.")
