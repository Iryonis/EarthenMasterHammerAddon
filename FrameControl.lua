--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- Functions to control the frames ---------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables and constants
--------------------------------------------------------------------------------

local tooltip

--------------------------------------------------------------------------------
--- Compartment functions
--------------------------------------------------------------------------------

--[[
Create the compartment tooltip
If the tooltip already exists, just update the text

@param button - The button that the tooltip is attached to
]]
function EMH_AddonCompartmentEnter(_, button)
    if (not tooltip) then
        tooltip = CreateFrame("GameTooltip", "AddonCompartmentTooltip", UIParent, "GameTooltipTemplate")
    end

    tooltip:SetOwner(button, "ANCHOR_LEFT");
    tooltip:SetText(L["EMH"])
    tooltip:AddLine(L["COMPARTMENT_LEFT"], 1, 1, 1)
    tooltip:AddLine(L["COMPARTMENT_RIGHT"], 1, 1, 1)
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
- If the left button is clicked, show the main frame
- If the right button is clicked, show the settings frame

@param button - The button that was clicked
]]
function EMH_AddonCompartmentClick(_, button)
    if button == "LeftButton" then
        SettingsFrame:Hide()
        MainFrame:Show()
    elseif button == "RightButton" then
        MainFrame:Hide()
        SettingsFrame:Show()
    end
end

--------------------------------------------------------------------------------
--- Toggle functions
--------------------------------------------------------------------------------

--[[
Toggle the visibility of the main frame (used in the slash command and the compartment)
]]
function MainFrameToggle()
    if MainFrame:IsVisible() then
        MainFrame:Hide()
    else
        SettingsFrame:Hide()
        MainFrame:Show()
    end
end

--[[
Show the frame that is currently hidden and hide the one that is currently shown
Save the position of the frame that is being hidden and set it as the position of the frame that is shown
]]
function FrameToggle()
    if MainFrame:IsVisible() then
        MainFrame:Hide()
        SettingsFrame:Show()
    else
        SettingsFrame:Hide()
        MainFrame:Show()
    end
end
