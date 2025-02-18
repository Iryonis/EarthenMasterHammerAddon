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

-- Save the given frame position in the database
function SaveFramePosition(frame)
    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
    EMHDB.framePos = {
        point = point,
        relativeTo = relativeTo and relativeTo:GetName() or "UIParent",
        relativePoint = relativePoint,
        xOfs = xOfs,
        yOfs = yOfs
    }
end

-- Set the given frame position from the database (or center it if no position is saved)
function SetFramePosition(frame)
    if EMHDB and EMHDB.framePos then
        frame:ClearAllPoints()
        frame:SetPoint(EMHDB.framePos.point, EMHDB.framePos.relativeTo, EMHDB.framePos.relativePoint, EMHDB.framePos
            .xOfs, EMHDB.framePos.yOfs)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end
