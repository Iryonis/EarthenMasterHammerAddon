--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- Functions to change the frames position -------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables and constants
--------------------------------------------------------------------------------


FRAMES_WIDTH = 520           -- Width of the frames
FRAMES_HEIGHT = 300          -- Height of the frames

FRAME_POSITION_MERCHANTS = { -- Position of the frames when the merchant frame is visible
    point = "TOP",
    relativeTo = MerchantFrame,
    relativePoint = "TOPRIGHT",
    xOfs = 298,
    yOfs = 0
}
local frame_position_default = { -- Default position of the frames
    point = "CENTER",
    relativePoint = "CENTER",
    xOfs = 0,
    yOfs = 0
}
local RELATIVE_TO_DEFAULT = UIParent -- Default relativeTo value

--------------------------------------------------------------------------------
--- Miscellaneous functions
--------------------------------------------------------------------------------

--- Frame position functions

--[[
Check if the given frame is still entirely on the screen

@param frame - The frame to check
@return boolean - True if the frame is entirely on the screen, false otherwise
]]

local function isFrameOnScreen(frame)
    local left = frame:GetLeft()
    local right = frame:GetRight()
    local top = frame:GetTop()
    local bottom = frame:GetBottom()

    return left and right and top and bottom and left >= 0 and right <= GetScreenWidth() and top <= GetScreenHeight() and
        bottom >= 0
end

--[[
Reset EMHDB.framePos and the given frame to the default position

@param frame - The frame to reset the position of
]]
local function resetFramePosition(frame)
    EMHDB.framePos = frame_position_default
    frame:ClearAllPoints()
    frame:SetPoint(frame_position_default.point, RELATIVE_TO_DEFAULT, frame_position_default.relativePoint,
        frame_position_default
        .xOfs, frame_position_default.yOfs)
end

--[[
Put the frame position to the default one (center of the screen)

@param frame - The frame to reset the position of
]]

function DefaultFramePosition(frame)
    if not frame then
        error(string.format(L["ERROR_NOT_A_FRAME"], "DefaultFramePosition"))
    end

    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

--[[
Save the position of the given frame in the database (except for the relative point, which is always UIParent)
If the frame is not on the screen, reset the position to the default one

If a merchant frame that can repair is open, don't save the position of the frame (general case)
If the frame is anchored to UIParent (or nil (I don't know why but relativeTo is often nil)),
save the position (case where the merchant frame has just been closed)

@param frame - The frame to save the position of
]]
function SaveFramePosition(frame)
    if not frame then
        error(string.format(L["ERROR_NOT_A_FRAME"], "SaveFramePosition"))
    end
    if not isFrameOnScreen(frame) then
        resetFramePosition(frame)
    else
        if not (MerchantFrame and MerchantFrame:IsVisible() and CanMerchantRepair()) then
            local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()

            if not relativeTo or (relativeTo and relativeTo:GetName() == "UIParent") then
                EMHDB.framePos = {
                    point = point,
                    relativeTo = RELATIVE_TO_DEFAULT,
                    relativePoint = relativePoint,
                    xOfs = xOfs,
                    yOfs = yOfs
                }
            end
        end
    end
end

--[[
Set the given frame a position either from the database, or the merchant one if the merchant frame is open
If the database isn't set, set the frame to the default position

@param frame - The frame to set the position of
]]
function SetFramePosition(frame)
    if not frame then
        error(string.format(L["ERROR_NOT_A_FRAME"], "SetFramePosition"))
    end
    if EMHDB and EMHDB.framePos then
        frame:ClearAllPoints()
        if MerchantFrame and MerchantFrame:IsVisible() then
            frame:SetPoint(FRAME_POSITION_MERCHANTS.point, FRAME_POSITION_MERCHANTS.relativeTo,
                FRAME_POSITION_MERCHANTS.relativePoint,
                FRAME_POSITION_MERCHANTS.xOfs, FRAME_POSITION_MERCHANTS.yOfs)
        else
            frame:SetPoint(EMHDB.framePos.point, RELATIVE_TO_DEFAULT, EMHDB.framePos.relativePoint, EMHDB.framePos
                .xOfs, EMHDB.framePos.yOfs)
        end
    else
        DefaultFramePosition(frame)
    end
end
