--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- Variables and misceallenous functions ---------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Variables and constants
--------------------------------------------------------------------------------


FRAMES_WIDTH = 520  -- Width of the frames
FRAMES_HEIGHT = 300 -- Height of the frames
_, L = ...          -- Localization

--------------------------------------------------------------------------------
--- Miscellaneous functions
--------------------------------------------------------------------------------

--- Frame position functions

--[[
Check if the given frame is still entirely on the screen
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
Reset EMHDB.framePos to the default position
]]
local function resetFramePosition()
    EMHDB.framePos = {
        point = "CENTER",
        relativePoint = "CENTER",
        xOfs = 0,
        yOfs = 0
    }
end

--[[
Put the frame position to the default one

@param frame The frame to reset the position of
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

@param frame The frame to save the position of
]]
function SaveFramePosition(frame)
    if not frame then
        error(string.format(L["ERROR_NOT_A_FRAME"], "SaveFramePosition"))
    end
    if not isFrameOnScreen(frame) then
        resetFramePosition()
    else
        local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
        EMHDB.framePos = {
            point = point,
            relativePoint = relativePoint,
            xOfs = xOfs,
            yOfs = yOfs
        }
    end
end

--[[
 Set the given frame position from the database (or center it if no position is saved)
The relative point is always UIParent to prevent bugs.

@param frame The frame to set the position of
]]
function SetFramePosition(frame)
    if not frame then
        error(string.format(L["ERROR_NOT_A_FRAME"], "SetFramePosition"))
    end
    if EMHDB and EMHDB.framePos then
        frame:ClearAllPoints()
        frame:SetPoint(EMHDB.framePos.point, UIParent, EMHDB.framePos.relativePoint, EMHDB.framePos
            .xOfs, EMHDB.framePos.yOfs)
    else
        DefaultFramePosition(frame)
    end
end
