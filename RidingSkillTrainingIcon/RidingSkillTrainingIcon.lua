-- A namespace for our sub addon
local Self = {}
ZAB.RidingSkillTrainingIcon = Self

local LABEL = "RidingSkillTrainingIcon"
local ID = "ZAB_" .. LABEL


--
local function OnMountInfoUpdated()
    local inventoryBonus, maxInventoryBonus, staminaBonus, maxStaminaBonus, speedBonus, maxSpeedBonus = GetRidingStats()
    local maxedOut = (inventoryBonus == maxInventoryBonus) and (staminaBonus == maxStaminaBonus) and (speedBonus == maxSpeedBonus)
    local remaining, _ = GetTimeUntilCanBeTrained()
    local showIcon = (not maxedOut) and (remaining < 1000)
    ZAB.Debug(LABEL, "OnMountInfoUpdated", { showIcon = showIcon })
    ZAB.NotificationIcons.SetVisible("/esoui/art/mounts/tabicon_ridingskills_up.dds", showIcon)
    if showIcon then
        ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NEGATIVE_CLICK, ZAB.lang.MOUNT_TRAINING_REMINDER_ALERT)
    end
end


--
function Self.IsEnabled()
    return ZAB.Settings.ridingSkillTraining.remainderIcon
end


-- Enable/Initialize the functionality iff isEnabled
function Self.SetEnabled(isEnabled)
    ZAB.Debug(LABEL, "SetEnabled", { isEnabled = isEnabled })
    ZAB.Settings.ridingSkillTraining.remainderIcon = isEnabled
    if isEnabled then
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_MOUNT_INFO_UPDATED, OnMountInfoUpdated)
        OnMountInfoUpdated()
    else
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_MOUNT_INFO_UPDATED)
        ZAB.NotificationIcons.SetVisible("/esoui/art/mounts/tabicon_ridingskills_up.dds", false)
    end
end
