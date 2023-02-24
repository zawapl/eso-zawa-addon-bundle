-- A namespace for our sub addon
local StaticIcon = {
    id = "ZAB_StaticIcon"
}

ZAB.StaticIcon = StaticIcon


function StaticIcon.IsEnabled()
    return ZAB.Settings.staticIcon
end


function StaticIcon.SetEnabled(isEnabled)
    ZAB.Settings.staticIcon = isEnabled
    ZAB.NotificationIcons.SetVisible(ZAB_StaticIcon, isEnabled)
end
