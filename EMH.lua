--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------- Initialization of the addon, the database and the settings ----------
--------------------------------------------------------------------------------
--- Variables and constants needed at initialization
--------------------------------------------------------------------------------

_, L = ...                   -- Localization
IsMerchantFrameOpen = false  -- True if the merchant frame is open

local badProfession = false  -- True if the player doesn't have the right profession (Blacksmithing)
local number_item_repaired   -- Number of items repaired
local VERSION = "1.0.0"      -- Version of the addon
local BLACKSMITHING_ID = 164 -- ID of the Blacksmithing profession
local HAMMER_ID = 225660     -- ID of the Earthen Master's Hammer
local TICKER = 0.1           -- Ticker duration in seconds

local ID_TO_NAME = {
    [1] = "head",
    [3] = "shoulder",
    [5] = "chest",
    [6] = "waist",
    [7] = "legs",
    [8] = "feet",
    [9] = "wrist",
    [10] = "hands",
    [16] = "mainHand",
    [17] = "offHand",
}

local SETTINGS = {
    {
        settingText = L["head_node"],
        settingKey = "head",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["head_node"]),
    },
    {
        settingText = L["shoulder_node"],
        settingKey = "shoulder",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["shoulder_node"]),
    },
    {
        settingText = L["chest_node"],
        settingKey = "chest",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["chest_node"]),
    },
    {
        settingText = L["waist_node"],
        settingKey = "waist",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["waist_node"]),
    },
    {
        settingText = L["legs_node"],
        settingKey = "legs",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["legs_node"]),
    },
    {
        settingText = L["feet_node"],
        settingKey = "feet",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["feet_node"]),
    },
    {
        settingText = L["wrists_node"],
        settingKey = "wrist",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["wrists_node"]),
    },
    {
        settingText = L["hands_node"],
        settingKey = "hands",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["hands_node"]),
    },
    {
        settingText = L["mainHandSettings"],
        settingKey = "mainHand",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["mainHand_node"]),
    },
    {
        settingText = L["offHandSettings"],
        settingKey = "offHand",
        settingTooltip = string.format(L["SETTINGS_TOOLTIP"], L["offHand_node"]),
    },
}

--------------------------------------------------------------------------------
--- Functions needed at initialization
--------------------------------------------------------------------------------

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
    if not MainFrame then
        error(string.format(L["ERROR_NOT_A_FRAME"], "openEMHMerchant"))
    end
    if (CanMerchantRepair() and checkRepairNeeded()) then
        IsMerchantFrameOpen = true
        SettingsFrame:Hide()
        MainFrame:Show()
    end
end

--[[
Close the EMH frame if the merchant frame opened could repair and update the position of the frames
]]
local function closeEMHMerchant()
    IsMerchantFrameOpen = false
    MainFrame:Hide()
    SettingsFrame:Hide()
end

--- Profession functions

--[[
Get the id of the profession at the given index

@param professionIndex: the index of the profession
@return the id of the profession at the given index or nil if the index is not a number
]]
local function getProfessionId(professionIndex)
    if type(professionIndex) ~= "number" then
        print(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(professionIndex)))
        return nil
    end

    local _, _, _, _, _, _, skillId, _, _, _ = GetProfessionInfo(professionIndex)
    return skillId
end

--[[
Check if the player has the Blacksmithing profession
]]
function CheckProfession()
    local profession1, profession2, _, _, _ = GetProfessions()

    if not profession1 and not profession2 then
        badProfession = true
        return false
    end

    local skill1 = getProfessionId(profession1)
    local skill2 = getProfessionId(profession2)

    if skill1 ~= BLACKSMITHING_ID and skill2 ~= BLACKSMITHING_ID then
        badProfession = true
    else
        badProfession = false
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
    elseif (event == "MERCHANT_SHOW" and not badProfession) then
        openEMHMerchant()
    elseif (event == "MERCHANT_CLOSED" and not badProfession) then
        closeEMHMerchant()
    end
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------- Creation and initialization of the main frame -----------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Local variables and constants
--------------------------------------------------------------------------------

local tempRepairCost, currentRepairCost, totalRepairCost

--------------------------------------------------------------------------------
--- Miscellaneous functions
--------------------------------------------------------------------------------
---

--[[
Format a number with commas or spaces in a string depending on the Locale
If French (frFR): 155425 -> "155 425"
Else: 155425 -> "155,425"

@param number: the number to format
@return the formatted number in a string
]]
local function formatNumberWithCommas(number)
    -- Check if "number" is of type number
    if type(number) ~= "number" then
        error(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(number)))
    end

    local formatted = tostring(number)
    local format

    -- Check the locale and set the format accordingly
    if GetLocale() == "frFR" then
        format = '%1 %2'
    else
        format = '%1,%2'
    end

    -- Format the number with commas or spaces and return
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", format)
        if k == 0 then
            break
        end
    end

    return formatted
end

--[[
Format money in string with text
Example with 155425 -> "15 gold, 54 silver, 25 copper"

@param money: the amount of money to format
@return the formatted money in a string
]]
local function formatMoney(money)
    -- Check if "money" is of type number
    if type(money) ~= "number" then
        error(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(money)))
    end
    -- If money is 0, return 0 formatted
    if money == 0 then
        return string.format(L["FORMAT_MONEY"], 0, 0, 0)
    end

    local gold = math.floor(money / 10000)
    local silver = math.floor((money % 10000) / 100)
    local copper = money % 100

    return string.format(L["FORMAT_MONEY"], formatNumberWithCommas(gold), silver, copper)
end


--[[
Check if the player has the hammer in his inventory
Only work the first time the player opens the MainFrame

@param id: the id of the hammer
]]
local function checkHammerPresence(id)
    local itemName
    if type(id) ~= "number" then
        error(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(id)))
    end

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
MainFrame:Hide()
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

goToSettingsButton:SetScript("OnClick", function(self)
    FrameToggle()
end)

MainFrame:EnableMouse(true)
MainFrame:SetMovable(true)

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
local function updateToRepairParameter()
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
@param item_number: the number of the item which is being repaired
@return true if the item has full durability or isn't checked in the settings, false otherwise
]]
local function testAndUpdateButton(i, item_number)
    if not performTest(i) then
        -- Update the repair button and wait for the users to click on it
        useItemButton:SetText(string.format(L["REPAIR_BUTTON"], L[ID_TO_NAME[EMHDB.keys[i]]], item_number,
            EMHDB.to_repair))
        useItemButton:SetAttribute("macrotext", string.format(L["MACRO"], EMHDB.keys[i]))
        return false
    end
    -- Go to the next item
    return true
end

--[[
Compute the gold saved and update the goldSaved text in the MainFrame
]]
local function computeGoldSaved()
    tempRepairCost, _ = GetRepairAllCost()

    local gold_saved = currentRepairCost - tempRepairCost
    EMHDB.goldSaved = EMHDB.goldSaved + gold_saved
    if gold_saved > 0 then
        MainFrame.goldSaved:SetText(formatMoney(EMHDB.goldSaved))
    end

    currentRepairCost = currentRepairCost - gold_saved
    tempRepairCost, gold_saved = 0, 0
end

--[[
Update the text of the repair button and compute the total gold saved to print it in the chat
]]
local function finalizeRepairs()
    useItemButton:SetText(L["NO_REPAIR"])

    local total_gold_saved = totalRepairCost - currentRepairCost
    if total_gold_saved > 0 then
        print(string.format(L["SAVED_MONEY_PRINT"], formatMoney(total_gold_saved)))
    end

    totalRepairCost, currentRepairCost = 0, 0
end

-- Function declared here to avoid a circular dependency
local runTestsInstantly, waitForUserToRepair

--[[
Wait for the user to repair the item then update i and item_number, and run the tests again
Use a ticker to check the durability every {TICKER} seconds

@param i: the index of the item to check
@param item_number: the number of the item which is being repaired
]]
waitForUserToRepair = function(i, item_number)
    -- Check if the frame is still open
    if not MainFrame:IsShown() then
        return
    end
    if testAndUpdateButton(i, item_number) then
        i = i + 1
        item_number = item_number + 1
        computeGoldSaved()

        runTestsInstantly(i, item_number)
    else
        C_Timer.After(TICKER, function() waitForUserToRepair(i, item_number) end)
    end
end


--[[
Run all tests instantly to check if any items need to be repaired
If a repair is needed, start the ticker to check durability every second until the item is repaired

@param i: the index of the item to check
@param item_number: the number of the item which is being repaired
]]
runTestsInstantly = function(i, item_number)
    number_item_repaired = number_item_repaired + 1
    if type(i) ~= "number" then
        error(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(i)))
    elseif type(item_number) ~= "number" then
        error(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(item_number)))
    end

    while i <= #EMHDB.keys do
        if not performTest(i) then
            -- If a repair is needed, start the ticker
            waitForUserToRepair(i, item_number)
            return
        end
        i = i + 1
    end
    -- If no repair is needed, call the end function
    finalizeRepairs()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------- Scripts and command -------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Scripts
--------------------------------------------------------------------------------

-- Make the frame movable
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
MainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

-- Update the goldSaved and run the tests for the repair button
MainFrame:SetScript("OnShow", function()
    SetFramePosition(MainFrame)
    number_item_repaired = -1
    MainFrame.goldSaved:SetText(formatMoney(EMHDB.goldSaved))

    totalRepairCost, _ = GetRepairAllCost()
    currentRepairCost = totalRepairCost
    updateToRepairParameter()
    runTestsInstantly(1, 1)
end)

-- Update economy and save position
MainFrame:SetScript("OnHide", function()
    finalizeRepairs()
    SaveFramePosition(MainFrame)
end)

-- Reset the position of the frame when right-clicking on it
MainFrame:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
        DefaultFramePosition(MainFrame)
    end
end)

--------------------------------------------------------------------------------
--- Slash command
--------------------------------------------------------------------------------


SLASH_EMH1 = "/emh"
SlashCmdList.EMH = function()
    -- Check if the player has the right profession: Blacksmithing
    if badProfession then
        return
    end

    -- Check if the player has the hammer in his inventory
    checkHammerPresence(HAMMER_ID)

    -- Toggle the frames
    MainFrameToggle()
end
