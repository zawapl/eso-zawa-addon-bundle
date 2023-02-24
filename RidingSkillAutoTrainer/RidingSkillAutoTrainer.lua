-- A namespace for our sub addon
local Self = { }
ZAB.RidingSkillAutoTrainer = Self

local LABEL = "RidingSkillAutoTrainer"
local ID = "ZAB_" .. LABEL
local PRIORITY_LISTS = {
    { RIDING_TRAIN_SPEED, RIDING_TRAIN_STAMINA, RIDING_TRAIN_CARRYING_CAPACITY },
    { RIDING_TRAIN_SPEED, RIDING_TRAIN_CARRYING_CAPACITY, RIDING_TRAIN_STAMINA },
    { RIDING_TRAIN_STAMINA, RIDING_TRAIN_SPEED, RIDING_TRAIN_CARRYING_CAPACITY },
    { RIDING_TRAIN_STAMINA, RIDING_TRAIN_CARRYING_CAPACITY, RIDING_TRAIN_SPEED },
    { RIDING_TRAIN_CARRYING_CAPACITY, RIDING_TRAIN_SPEED, RIDING_TRAIN_STAMINA },
    { RIDING_TRAIN_CARRYING_CAPACITY, RIDING_TRAIN_STAMINA, RIDING_TRAIN_SPEED }
}


-- define local function
local OnMountInfoUpdated;


-- When purchase successful, close stable
local function OnRidingSkillImproved(_, _, _, _, source)
    if source == RIDING_TRAIN_SOURCE_STABLES then
        ZAB.Debug(LABEL, "OnRidingSkillImproved successful")
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_RIDING_SKILL_IMPROVEMENT)
        OnMountInfoUpdated();
        EndInteraction(INTERACTION_STABLE)
    else
        ZAB.Debug(LABEL, "OnRidingSkillImproved unsuccessful", { source = source })
    end
end


-- When entering stable, try to purchase the skill based on the provided priority
local function OnStableInteractStart()
    ZAB.Debug(LABEL, "OnStableInteractStart")

    EVENT_MANAGER:UnregisterForEvent(ID, EVENT_STABLE_INTERACT_START)
    EVENT_MANAGER:RegisterForEvent(ID, EVENT_RIDING_SKILL_IMPROVEMENT, OnRidingSkillImproved)

    local inventoryBonus, maxInventoryBonus, staminaBonus, maxStaminaBonus, speedBonus, maxSpeedBonus = GetRidingStats()

    for _, v in ipairs(PRIORITY_LISTS[1]) do
        if v == RIDING_TRAIN_CARRYING_CAPACITY then
            if inventoryBonus < maxInventoryBonus then
                ZAB.Debug(LABEL, "OnStableInteractStart RIDING_TRAIN_CARRYING_CAPACITY")
                TrainRiding(RIDING_TRAIN_CARRYING_CAPACITY)
                break
            end
        elseif v == RIDING_TRAIN_SPEED then
            if speedBonus < maxSpeedBonus then
                ZAB.Debug(LABEL, "OnStableInteractStart RIDING_TRAIN_SPEED")
                TrainRiding(RIDING_TRAIN_SPEED)
                break
            end
        elseif v == RIDING_TRAIN_STAMINA then
            if staminaBonus < maxStaminaBonus then
                ZAB.Debug(LABEL, "OnStableInteractStart RIDING_TRAIN_STAMINA")
                TrainRiding(RIDING_TRAIN_STAMINA)
                break
            end
        else
            ZAB.Debug(LABEL, "OnStableInteractStart not trained", { RidingTrainType = v })
        end
    end

    zo_callLater(function()
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_RIDING_SKILL_IMPROVEMENT)
    end, 1000)
end


-- Handles initial conversation of talking to the Stablemaster
local function OnChatterBegin(_, optionCount)
    for i = 1, optionCount do
        local _, optionType = GetChatterOption(1)

        if optionType == CHATTER_START_STABLE then
            ZAB.Debug(LABEL, "OnChatterBegin CHATTER_START_STABLE")
            EVENT_MANAGER:RegisterForEvent(ID, EVENT_STABLE_INTERACT_START, OnStableInteractStart)
            SelectChatterOption(i)
            zo_callLater(function()
                EVENT_MANAGER:UnregisterForEvent(ID, EVENT_STABLE_INTERACT_START)
            end, 1000)
            break
        end
    end
end


-- Iff riding skill can noe be improved register to lister to start chatter
function OnMountInfoUpdated()
    local inventoryBonus, maxInventoryBonus, staminaBonus, maxStaminaBonus, speedBonus, maxSpeedBonus = GetRidingStats()
    local maxedOut = (inventoryBonus == maxInventoryBonus) and (staminaBonus == maxStaminaBonus) and (speedBonus == maxSpeedBonus)
    local remaining, _ = GetTimeUntilCanBeTrained()
    local canTrain = (not maxedOut) and (remaining < 1000)

    if canTrain then
        ZAB.Debug(LABEL, "OnMountInfoUpdated", { RegisterForEvent = "EVENT_CHATTER_BEGIN" })
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_CHATTER_BEGIN, OnChatterBegin)
    else
        ZAB.Debug(LABEL, "OnMountInfoUpdated", { UnregisterForEvent = "EVENT_CHATTER_BEGIN" })
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_CHATTER_BEGIN)
    end
end


--
local function RidingTrainTypeToIcon(ridingTrainType)
    if ridingTrainType == RIDING_TRAIN_CARRYING_CAPACITY then
        return "/esoui/art/mounts/gamepad/gp_ridingskill_capacity.dds"
    elseif ridingTrainType == RIDING_TRAIN_SPEED then
        return "/esoui/art/mounts/gamepad/gp_ridingskill_speed.dds"
    else
        return "/esoui/art/mounts/gamepad/gp_ridingskill_stamina.dds"
    end
end


--
function Self.GetPriorityListChoices()
    return { 1, 2, 3, 4, 5, 6 }
end


--
function Self.GetPriorityListChoiceLabels()
    local result = {}
    for i, list in ipairs(PRIORITY_LISTS) do
        local label = ""
        for _, ridingTrainType in ipairs(list) do
            local icon = RidingTrainTypeToIcon(ridingTrainType)
            label = label .. string.format("|t32:32:%s:inheritcolor|t", icon)
        end
        result[i] = label
    end
    return result
end


--
function Self.IsEnabled()
    return ZAB.Settings.ridingSkillTraining.automated
end


-- Enable/Initialize the functionality iff isEnabled
function Self.SetEnabled(isEnabled)
    ZAB.Debug(LABEL, "SetEnabled", { isEnabled = isEnabled })
    ZAB.Settings.ridingSkillTraining.automated = isEnabled
    if isEnabled then
        OnMountInfoUpdated()
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_MOUNT_INFO_UPDATED, OnMountInfoUpdated)
    else
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_MOUNT_INFO_UPDATED)
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_CHATTER_BEGIN)
    end
end


--
function Self.GetPriorityListID()
    return ZAB.Settings.ridingSkillTraining.skillPriorityListId
end


--
function Self.SetPriorityListID(newVal)
    ZAB.Settings.ridingSkillTraining.skillPriorityListId = newVal
end
