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
    ZAB.NotificationIcons.SetVisible(ZAB_RidingSkillTrainingIcon, showIcon)
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
        ZAB.NotificationIcons.SetVisible(ZAB_RidingSkillTrainingIcon, false)
    end
end

-- Look at my |t32:32:esoui/art/icons/mounticon_horse_a.dds|t