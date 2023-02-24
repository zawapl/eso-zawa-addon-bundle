-- A namespace for our sub addon
local CombatIcon = {
    id = "ZAB_CombatIcon"
}

ZAB.CombatIcon = CombatIcon


local function RefreshCombatIcon()
    ZAB.NotificationIcons.SetVisible(ZAB_CombatIcon, not IsUnitInCombat("player"))
end


function CombatIcon.IsEnabled()
    return ZAB.Settings.combatIcon
end


function CombatIcon.SetEnabled(isEnabled)
    ZAB.Settings.combatIcon = isEnabled
    if isEnabled then
        EVENT_MANAGER:RegisterForEvent(CombatIcon.id, EVENT_PLAYER_COMBAT_STATE, RefreshCombatIcon)
        RefreshCombatIcon()
    else
        EVENT_MANAGER:UnregisterForEvent(CombatIcon.id, EVENT_PLAYER_COMBAT_STATE)
        ZAB.NotificationIcons.SetVisible(ZAB_CombatIcon, false)
    end
end
