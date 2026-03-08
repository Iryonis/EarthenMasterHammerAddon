--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------- Initialization of the addon, the database and the settings ----------
--------------------------------------------------------------------------------
--- Variables and constants needed at initialization
--------------------------------------------------------------------------------
---
-- Get the addon version from .toc
local addonName, addonTable = ... -- Addon table
addonTable.VERSION = C_AddOns.GetAddOnMetadata(addonName, "Version")

addonTable.isMerchantFrameOpen = false -- True if the merchant frame is open

local _, L = ...                       -- Localization
local VERSION = addonTable.VERSION     -- Version of the addon
local TICKER = 0.1                     -- Ticker duration in seconds
local sortedKeys                       -- Sorted table to store the keys and durability percentage of the items to repair

--------------------------------------------------------------------------------
--- Functions needed at initialization
--------------------------------------------------------------------------------

-- Check the durability of the given item

-- @param itemKey: the key of the item to check (1 for head, 3 for shoulder, etc.)
-- @return true if the item has full durability or isn't checked in the settings, false otherwise
local function performTest(itemKey)
    local current, maximum = GetInventoryItemDurability(itemKey)
    if current and maximum and current < maximum then
        return false
    end
    return true
end

--[[
Check if the player needs to repair any items (using capabilities)

@return true if at least one equipped item can and needs to be repaired
]]
local function checkRepairNeeded()
    for _, slotID in ipairs(addonTable.ALL_REPAIR_SLOTS) do
        local canRepair, _ = EMH_CanRepairSlot(slotID)
        if canRepair then
            local current, maximum = GetInventoryItemDurability(slotID)
            if current and maximum and current < maximum then
                return true
            end
        end
    end
    return false
end

--[[
Open the EMH frame (to the right of the merchant frame) if:
- the merchant can repair
- the player needs to repair his items
]]
local function openEMHMerchant()
    if not addonTable.mainFrame then
        error(string.format(L["ERROR_NOT_A_FRAME"], "openEMHMerchant"))
    end
    if (CanMerchantRepair() and checkRepairNeeded()) then
        addonTable.isMerchantFrameOpen = true
        addonTable.settingsFrame:Hide()
        addonTable.mainFrame:Show()
    end
end

--[[
Close the EMH frame if the merchant frame opened could repair and update the position of the frames
]]
local function closeEMHMerchant()
    addonTable.isMerchantFrameOpen = false
    addonTable.mainFrame:Hide()
    addonTable.settingsFrame:Hide()
end

-- Profession check and capability scanning are handled by Capabilities.lua
-- (EMH_ScanCapabilities, EMH_CanRepairSlot, EMH_GetCapabilities)

--------------------------------------------------------------------------------
--- Initialization
--------------------------------------------------------------------------------

-- Initialize the database and the settings
local eventListenerFrame = CreateFrame("Frame", "EMHSettingsEventListenerFrame", UIParent)

eventListenerFrame:RegisterEvent("PLAYER_LOGIN")
eventListenerFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventListenerFrame:RegisterEvent("MERCHANT_SHOW")
eventListenerFrame:RegisterEvent("MERCHANT_CLOSED")
eventListenerFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")

eventListenerFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        -- Initialize database
        if not EMHDB then
            EMHDB = {}
        end

        -- Clean up obsolete database keys from previous versions
        EMHDB.settingsKeys = nil
        EMHDB.keys = nil
        EMHDB.to_repair = nil

        -- Total gold saved by the addon
        if not EMHDB.goldSaved then
            EMHDB.goldSaved = 0
        end

        -- Position of the frames
        if not EMHDB.framePos then
            EMHDB.framePos = {}
            EMH_SaveFramePosition(addonTable.mainFrame)
        end

        -- Load capabilities from cache, or scan talent trees if no cache exists
        EMH_LoadCapabilities()

        if addonTable.addonDisabled then
            if addonTable.disableReason == "no_blacksmithing" then
                print(L["NO_BLACKSMITHING"])
            elseif addonTable.disableReason == "no_repair_nodes" then
                print(L["NO_REPAIR_NODES"])
            end
        end
    elseif event == "TRAIT_CONFIG_UPDATED" then
        EMH_ScanCapabilities()
    elseif (event == "PLAYER_REGEN_DISABLED" and not addonTable.addonDisabled) then
        closeEMHMerchant()
    elseif (event == "MERCHANT_SHOW" and not addonTable.addonDisabled and not InCombatLockdown()) then
        openEMHMerchant()
    elseif (event == "MERCHANT_CLOSED" and not addonTable.addonDisabled and not InCombatLockdown()) then
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
Format money in string with Blizzard money icons
Example with 155425 -> "15 gold icon, 54 silver icon, 25 copper icon"

@param money: the amount of money to format
@return the formatted money in a string
]]
local function formatMoney(money)
    -- Check if "money" is of type number
    if type(money) ~= "number" then
        error(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(money)))
    end

    return C_CurrencyInfo.GetCoinTextureString(money)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------- Create the addonTable.mainFrame ------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Main Frame
--------------------------------------------------------------------------------

-- Create the main frame

addonTable.mainFrame = CreateFrame("Frame", "EMHMainFrame", UIParent, "BasicFrameTemplateWithInset")

addonTable.mainFrame:SetSize(addonTable.FRAMES_WIDTH, addonTable.FRAMES_HEIGHT)
addonTable.mainFrame:SetFrameStrata("DIALOG")
EMH_SetFramePosition(addonTable.mainFrame)
addonTable.mainFrame:Hide()
addonTable.mainFrame.TitleBg:SetHeight(30)
addonTable.mainFrame.title = addonTable.mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
addonTable.mainFrame.title:SetPoint("TOPLEFT", addonTable.mainFrame.TitleBg, "TOPLEFT", 5, -3)
addonTable.mainFrame.title:SetText(L["MAIN_FRAME_TITLE"])

addonTable.mainFrame.subTitle1 = addonTable.mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addonTable.mainFrame.subTitle1:SetPoint("TOP", addonTable.mainFrame, "TOP", 0, -35)
addonTable.mainFrame.subTitle1:SetText(L["SUB_TITLE"])
addonTable.mainFrame.goldSaved = addonTable.mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addonTable.mainFrame.goldSaved:SetPoint("TOP", addonTable.mainFrame.subTitle1, "BOTTOM", 0, -20)

-- Draw a horizontal line
addonTable.mainFrame.backgroundButtonRepair = addonTable.mainFrame:CreateTexture(nil, "ARTWORK")
addonTable.mainFrame.backgroundButtonRepair:SetColorTexture(1, 1, 1, 0.05) -- Set the color to WoW yellow
addonTable.mainFrame.backgroundButtonRepair:SetSize(480, 100)
addonTable.mainFrame.backgroundButtonRepair:SetPoint("TOP", addonTable.mainFrame.goldSaved, "BOTTOM", 0, -30)
-- Credits
addonTable.mainFrame.credits = addonTable.mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addonTable.mainFrame.credits:SetPoint("BOTTOM", addonTable.mainFrame, "BOTTOM", 0, 15)
addonTable.mainFrame.credits:SetText(string.format(L["CREDITS"], VERSION))

local horizontalLineCredits = addonTable.mainFrame:CreateTexture(nil, "ARTWORK")
horizontalLineCredits:SetColorTexture(1, 0.82, 0, 1) -- Set the color to WoW yellow
horizontalLineCredits:SetSize(240, 1)
horizontalLineCredits:SetPoint("TOP", addonTable.mainFrame.credits, "TOP", 0, 35)

-- Tooltip gold
local tooltipButton = CreateFrame("Button", nil, addonTable.mainFrame, "UIPanelButtonTemplate")
tooltipButton:SetSize(24, 24)
tooltipButton:SetPoint("TOPRIGHT", addonTable.mainFrame, "TOPRIGHT", -13, -30)
-- Create a font string for the "?"
local fontString = tooltipButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
fontString:SetPoint("CENTER", tooltipButton, "CENTER", 0, 0)
fontString:SetText("?")


-- Button "Go to settings frame"
local goToSettingsButton = CreateFrame("Button", "goToSettingsButton", addonTable.mainFrame, "UIPanelButtonTemplate")
goToSettingsButton:SetPoint("TOPRIGHT", addonTable.mainFrame, "TOPRIGHT", -25, 0)
goToSettingsButton:SetSize(150, 20)
goToSettingsButton:SetText(L["MAIN_TO_SETTINGS_BUTTON"])

goToSettingsButton:SetScript("OnClick", function(self)
    EMH_FrameToggle()
end)

addonTable.mainFrame:EnableMouse(true)
addonTable.mainFrame:SetMovable(true)

-- Add tooltip to the button
tooltipButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(L["GOLD_TOOLTIP"], 1, 0.82, 0, 1, true)
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

local useItemButton = CreateFrame("Button", "UseItemButton", addonTable.mainFrame,
    "SecureActionButtonTemplate, UIPanelButtonTemplate")
useItemButton:SetPoint("CENTER", addonTable.mainFrame, "CENTER", 0, -10)
useItemButton:SetSize(280, 40)
useItemButton:SetText(L["LOADING"])
useItemButton:RegisterForClicks("AnyUp", "AnyDown")
useItemButton:SetAttribute("type1", "macro")

--------------------------------------------------------------------------------
--- Button repair's functions
--------------------------------------------------------------------------------

--[[
Check durability of all repairable slots (using capabilities) and build
a sorted list of items that need repair, ordered by durability % ascending.
]]
local function updateToRepairParameter()
    sortedKeys = {}
    for _, slotID in ipairs(addonTable.ALL_REPAIR_SLOTS) do
        local canRepair, hammerID = EMH_CanRepairSlot(slotID)
        if canRepair then
            local current, maximum = GetInventoryItemDurability(slotID)
            if current and maximum and current < maximum then
                local percentage = (current / maximum) * 100
                table.insert(sortedKeys, { key = slotID, percentage = percentage, hammerID = hammerID })
            end
        end
    end
    -- Sort the table by durability percentage (ascending order)
    table.sort(sortedKeys, function(a, b)
        return a.percentage < b.percentage
    end)
end

--[[
Check the durability of the items and update the button if a repair is needed

@param i: the index of the item to check
@param item_number: the number of the item which is being repaired
@return true if the item has full durability or isn't checked in the settings, false otherwise
]]
local function testAndUpdateButton(i, item_number)
    local entry = sortedKeys[i]
    local itemKey = entry.key
    if not performTest(itemKey) then
        -- Update the repair button and wait for the user to click on it
        useItemButton:SetText(string.format(L["REPAIR_BUTTON"], L[addonTable.ID_TO_NAME[itemKey]], item_number,
            #sortedKeys, entry.percentage))
        useItemButton:SetAttribute("macrotext", string.format(L["MACRO"], entry.hammerID, itemKey))
        return false
    end
    -- Go to the next item
    return true
end

--[[
Compute the gold saved and update the goldSaved text in the addonTable.mainFrame
]]
local function computeGoldSaved()
    tempRepairCost, _ = GetRepairAllCost()

    local gold_saved = currentRepairCost - tempRepairCost
    EMHDB.goldSaved = EMHDB.goldSaved + gold_saved
    if gold_saved > 0 then
        addonTable.mainFrame.goldSaved:SetText(formatMoney(EMHDB.goldSaved))
    end

    currentRepairCost = currentRepairCost - gold_saved
    tempRepairCost, gold_saved = 0, 0
end

--[[
Update the text and the macro of the repair button, and compute the total gold saved to print it in the chat
]]
local function finalizeRepairs()
    useItemButton:SetText(L["NO_REPAIR"])
    useItemButton:SetAttribute("macrotext", "/tmh")

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
    if not addonTable.mainFrame:IsShown() then
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
    if type(i) ~= "number" then
        error(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(i)))
    elseif type(item_number) ~= "number" then
        error(string.format(L["ERROR_BAD_TYPE_NUMBER"], type(item_number)))
    end

    while i <= #sortedKeys do
        if not performTest(sortedKeys[i].key) then
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
addonTable.mainFrame:RegisterForDrag("LeftButton")
addonTable.mainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
addonTable.mainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    EMH_SaveFramePosition(addonTable.mainFrame)
end)

-- Update the goldSaved and run the tests for the repair button
addonTable.mainFrame:SetScript("OnShow", function()
    EMH_SetFramePosition(addonTable.mainFrame)
    addonTable.mainFrame.goldSaved:SetText(formatMoney(EMHDB.goldSaved))

    totalRepairCost, _ = GetRepairAllCost()
    currentRepairCost = totalRepairCost
    updateToRepairParameter()
    runTestsInstantly(1, 1)
end)

-- Update economy and save position
addonTable.mainFrame:SetScript("OnHide", function()
    finalizeRepairs()
    EMH_SaveFramePosition(addonTable.mainFrame)
end)

-- Reset the position of the frame when right-clicking on it
addonTable.mainFrame:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
        EMH_DefaultFramePosition(addonTable.mainFrame)
    end
end)

--------------------------------------------------------------------------------
--- Slash command
--------------------------------------------------------------------------------

-- Open the main frame with /tmh
SLASH_EMH1 = "/tmh"
SlashCmdList.EMH = function()
    if addonTable.addonDisabled then
        return
    elseif InCombatLockdown() then
        print(L["CANT_OPEN_IN_COMBAT"])
        return
    end

    EMH_MainFrameToggle()
end

-- Check the durability of the items with /tmhcheck
SLASH_EMHCHECK1 = "/tmhcheck"
SlashCmdList.EMHCHECK = function()
    -- Create and fill the sortedKeys table using capabilities
    updateToRepairParameter()
    if (#sortedKeys ~= 0) then
        print(L["DURABILITY_TITLE"])
        for _, v in ipairs(sortedKeys) do
            local itemName
            if v.key == 16 or v.key == 17 then
                local cat = addonTable.getWeaponCategory(v.key)
                itemName = L[addonTable.CATEGORY_TO_NAME[cat]]
            else
                itemName = L[addonTable.ID_TO_NAME[v.key]]
            end
            print(string.format(L["DURABILITY_INFO"], itemName, v.percentage))
        end
    else
        print(L["DURABILITY_FULL"])
    end
end

-- Print detected repair capabilities to chat with /tmhcap
SLASH_EMHCAP1 = "/tmhcap"
SlashCmdList.EMHCAP = function()
    local armorCap, weaponCap = EMH_GetCapabilities()
    local hasTWW              = EMH_HasHammerInBags(addonTable.HAMMER_ID_TWW)
    local hasMidnight         = EMH_HasHammerInBags(addonTable.HAMMER_ID_MIDNIGHT)

    -- Returns a colored label for one source given node + hammer status.
    local function coloredLabel(labelStr, hasNode, hasHammer)
        local color
        if hasNode and hasHammer then
            color = "|cff00ff00"
        elseif hasNode or hasHammer then
            color = "|cffffff00"
        else
            color = "|cffff4444"
        end
        return color .. labelStr .. "|r"
    end

    -- Returns "TWW_colored / MN_colored" for a given cap entry.
    local function bothLabels(cap)
        local hasTWWNode = cap ~= nil and cap.tww == true
        local hasMNNode  = cap ~= nil and cap.midnight == true
        return coloredLabel(L["CAP_SOURCE_TWW"], hasTWWNode, hasTWW)
            .. " / "
            .. coloredLabel(L["CAP_SOURCE_MIDNIGHT"], hasMNNode, hasMidnight)
    end

    print(L["CAP_COMMAND_TITLE"])

    -- Hammer section
    print("[" .. L["CAP_HAMMERS"] .. "]")
    local twwHammerColor = hasTWW and "|cff00ff00" or "|cffff4444"
    local mnHammerColor  = hasMidnight and "|cff00ff00" or "|cffff4444"
    print("  " ..
        L["CAP_SOURCE_TWW"] .. ": " .. twwHammerColor .. (hasTWW and L["CAP_IN_BAGS"] or L["CAP_NOT_IN_BAGS"]) .. "|r")
    print("  " ..
        L["CAP_SOURCE_MIDNIGHT"] ..
        ": " .. mnHammerColor .. (hasMidnight and L["CAP_IN_BAGS"] or L["CAP_NOT_IN_BAGS"]) .. "|r")

    -- Armor slots
    print("[" .. L["CAP_ARMOR"] .. "]")
    for _, slotID in ipairs(addonTable.ARMOR_SLOTS_ORDER) do
        print("  " .. L[addonTable.ID_TO_NAME[slotID]] .. ": " .. bothLabels(armorCap[slotID]))
    end

    -- Weapon categories
    print("[" .. L["CAP_WEAPONS"] .. "]")
    for _, cat in ipairs(addonTable.WEAPON_CATS_ORDER) do
        print("  " .. L[addonTable.CATEGORY_TO_NAME[cat]] .. ": " .. bothLabels(weaponCap[cat]))
    end
end
