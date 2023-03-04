-- A namespace for our sub addon
local Self = {
}
ZAB.CraftingWritReminder = Self

local LABEL = "CraftingWritReminder"
local ID = "ZAB_" .. LABEL

local function OnQuestComplete(eventCode, questName, playerLevel, previousXP, currentXP, playerVeteranRank, previousVeteranPoints, currentVeteranPoints)
    -- "Clothier Writ"
    -- "Woodworker Writ"
    -- "Blacksmith Writ"
    ZAB.Debug(LABEL, "OnQuestComplete", { eventCode = eventCode, questName = questName, playerLevel = playerLevel })
end


-- Enable/disable research automator bar
function Self.SetEnabled(isEnabled)
    ZAB.Debug(LABEL, "SetEnabled", { isEnabled = isEnabled })

    if isEnabled then
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_QUEST_COMPLETE, OnQuestComplete)
    else
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_QUEST_COMPLETE)
    end
end