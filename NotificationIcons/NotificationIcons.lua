-- A namespace for our sub addon
local Self = {
    uiFragment = nil,
    icons = {}
}
ZAB.NotificationIcons = Self

local LABEL = "Test"
local ID = "ZAB_" .. LABEL

-- After updating offset or alignment recrete the anchor
local function RefreshAnchor()
    ZAB_NotificationIcons_Content:ClearAnchors()
    ZAB_NotificationIcons_Content:SetAnchor(ZAB.Settings.notificationIcons.alignment, ZAB_NotificationIcons, ZAB.Settings.notificationIcons.alignment, ZAB.Settings.notificationIcons.xOffset, ZAB.Settings.notificationIcons.yOffset)
end


-- Refresh the content to show the icons that are marked as visible
function Self.RefreshIcons()
    local label = ""
    for k, v in pairs(Self.icons) do
        if v then
            label = label .. string.format(" |t64:64:%s|t", k)
        end
    end
    ZAB_NotificationIcons_Content:SetText(label)
end


-- To show all icon from the settings view
function Self.ShowAllIcons()
    ZAB_NotificationIcons:SetHidden(false)
    local label = ""
    for k, _ in pairs(Self.icons) do
        label = label .. string.format("|t64:64:%s|t", k)
    end
    ZAB_NotificationIcons_Content:SetText(label)
end


-- Set the given icon texture to be visible
function Self.SetVisible(iconTexture, isVisible)
    if isVisible then
        Self.icons[iconTexture] = true
    else
        Self.icons[iconTexture] = false
    end
    Self.RefreshIcons()
end


-- Set X offset relative to anchor
function Self.SetXOffset(xOffset)
    ZAB.Settings.notificationIcons.xOffset = tonumber(xOffset)
    RefreshAnchor()
end


-- Get X offset
function Self.GetXOffset()
    return ZAB.Settings.notificationIcons.xOffset
end


-- Set Y offset relative to anchor
function Self.SetYOffset(yOffset)
    ZAB.Settings.notificationIcons.yOffset = tonumber(yOffset)
    RefreshAnchor()
end


-- Get Y offset
function Self.GetYOffset()
    return ZAB.Settings.notificationIcons.yOffset
end


-- Set alignment used for anchoring
function Self.SetAlignment(alignment)
    ZAB.Settings.notificationIcons.alignment = alignment
    RefreshAnchor()
end


-- Get anchor alignment
function Self.GetAlignment()
    return ZAB.Settings.notificationIcons.alignment
end


-- Get alignment labels for the settings dropdown
function Self.GetAlignmentLabels()
    return {
        ZAB.lang.NOTIFICATION_ICON_ALIGNMENT_TOP,
        ZAB.lang.NOTIFICATION_ICON_ALIGNMENT_LEFT,
        ZAB.lang.NOTIFICATION_ICON_ALIGNMENT_RIGHT,
        ZAB.lang.NOTIFICATION_ICON_ALIGNMENT_BOTTOM,
        ZAB.lang.NOTIFICATION_ICON_ALIGNMENT_TOP_LEFT,
        ZAB.lang.NOTIFICATION_ICON_ALIGNMENT_TOP_RIGHT,
        ZAB.lang.NOTIFICATION_ICON_ALIGNMENT_BOTTOM_LEFT,
        ZAB.lang.NOTIFICATION_ICON_ALIGNMENT_BOTTOM_RIGHT,
    }
end


-- Get alignment values for what gets set from the dropdows in settings
function Self.GetAlignmentValues()
    return {
        TOP,
        LEFT,
        RIGHT,
        BOTTOM,
        TOPLEFT,
        TOPRIGHT,
        BOTTOMLEFT,
        BOTTOMRIGHT,
    }
end


-- Is icon arrangement vertical
function Self.IsVertical()
    return ZAB.Settings.notificationIcons.vertical
end


-- Set icon arrangement to be vertical or not
function Self.SetVertical(isVertical)
    ZAB.Debug(LABEL, "SetVertical", { isVertical = isVertical })
    ZAB.Settings.notificationIcons.vertical = isVertical

    if isVertical then
        ZAB_NotificationIcons_Content:SetDimensionConstraints(64, 0, 64, AUTO_SIZE)
    else
        ZAB_NotificationIcons_Content:SetDimensionConstraints(0, 64, AUTO_SIZE, 64)
    end
end


-- Is the notification bar enabled
function Self.IsEnabled()
    return ZAB.Settings.notificationIcons.enabled
end


-- Enable/disable notification bar
function Self.SetEnabled(isEnabled)
    ZAB.Debug(LABEL, "SetEnabled", { isEnabled = isEnabled })
    ZAB.Settings.notificationIcons.enabled = isEnabled

    ZAB_NotificationIcons:SetHidden(not isEnabled)

    if not Self.uiFragment then
        Self.uiFragment = ZO_HUDFadeSceneFragment:New(ZAB_NotificationIcons, 1000, 500)
        Self.SetVertical(ZAB.Settings.notificationIcons.vertical)
        Self.SetAlignment(ZAB.Settings.notificationIcons.alignment)
    end

    if isEnabled then
        HUD_SCENE:AddFragment(Self.uiFragment)
        HUD_UI_SCENE:AddFragment(Self.uiFragment)
    else
        HUD_SCENE:RemoveFragment(Self.uiFragment)
        HUD_UI_SCENE:RemoveFragment(Self.uiFragment)
    end
end
