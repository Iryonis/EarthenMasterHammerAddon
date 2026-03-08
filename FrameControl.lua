--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- Functions to control the frames ---------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables and constants
--------------------------------------------------------------------------------

local tooltip             -- The compartment tooltip
local _, L = ...          -- Localization
local _, addonTable = ... -- Addon table

--------------------------------------------------------------------------------
--- Compartment functions
--------------------------------------------------------------------------------

--[[
Create the compartment tooltip
If the tooltip already exists, just update the text
If the player is in combat, add a warning line in red

@param button - The button that the tooltip is attached to
]]
function EMH_AddonCompartmentEnter(_, button)
    if (not tooltip) then
        tooltip = CreateFrame("GameTooltip", "AddonCompartmentTooltip", UIParent, "GameTooltipTemplate")
    end

    tooltip:SetOwner(button, "ANCHOR_LEFT");
    tooltip:SetText(L["EMH"], 1, 0.82, 0, 1, true)
    tooltip:AddLine(L["COMPARTMENT_LEFT"], 1, 1, 1)
    tooltip:AddLine(L["COMPARTMENT_RIGHT"], 1, 1, 1)
    if InCombatLockdown() then
        tooltip:AddLine(L["COMPARTMENT_INCOMBAT"], 1, 0, 0)
    end
    tooltip:Show()
end

--[[
Hide the compartment tooltip
]]
function EMH_AddonCompartmentLeave()
    tooltip:Hide()
end

--[[
Handle the click on the compartment:
- If the player is in combat, do nothing
- If the left button is clicked, show the main frame
- If the right button is clicked, show the settings frame

@param button - The button that was clicked
]]
function EMH_AddonCompartmentClick(_, button)
    if InCombatLockdown() then
        return
    end
    if button == "LeftButton" then
        addonTable.settingsFrame:Hide()
        addonTable.mainFrame:Show()
    elseif button == "RightButton" then
        addonTable.mainFrame:Hide()
        addonTable.settingsFrame:Show()
    end
end

--------------------------------------------------------------------------------
--- Toggle functions
--------------------------------------------------------------------------------

--[[
Toggle the visibility of the main frame (used in the slash command)
]]
function EMH_MainFrameToggle()
    if addonTable.mainFrame:IsVisible() then
        addonTable.mainFrame:Hide()
    else
        addonTable.settingsFrame:Hide()
        addonTable.mainFrame:Show()
    end
end

--[[
Show the frame that is currently hidden and hide the one that is currently shown
Save the position of the frame that is being hidden and set it as the position of the frame that is shown
]]
function EMH_FrameToggle()
    if addonTable.mainFrame:IsVisible() then
        addonTable.mainFrame:Hide()
        addonTable.settingsFrame:Show()
    else
        addonTable.settingsFrame:Hide()
        addonTable.mainFrame:Show()
    end
end
