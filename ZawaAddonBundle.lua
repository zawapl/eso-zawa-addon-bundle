-- Setup globals
ZAB = {
    id = "ZawaAddonBundle",
    version = "0.0.1",
    author = "ZawaPL",
    Settings = {
        ridingSkillTraining = {
            remainderIcon = false,
            automated = false,
            skillPriorityListId = 1
        },
        notificationIcons = {
            enabled = false,
            alignment = RIGHT,
            vertical = true,
            xOffset = 0,
            yOffset = 0
        },
        researchAutomator = {
            enabled = false,
            researchableSets = {}
        },
        questReminders = {
            lastCompleted = {
            }
        },
        debug = false
    }
}

-- Initialize all sub addons
local function InitializeSubAddons()
    ZAB.NotificationIcons.SetEnabled(true)
    ZAB.RidingSkillTrainingIcon.SetEnabled(ZAB.Settings.ridingSkillTraining.remainderIcon)
    ZAB.RidingSkillAutoTrainer.SetEnabled(ZAB.Settings.ridingSkillTraining.automated)

    ZAB.ResearchAutomator.SetEnabled(true)
    ZAB.ResearchReminder.SetEnabled(true)
    ZAB.CraftingWritReminder.SetEnabled(true)
end


-- Event handler to get notified when addon is loaded
EVENT_MANAGER:RegisterForEvent(ZAB.id, EVENT_ADD_ON_LOADED, function(_, addonId)
    if addonId == ZAB.id then
        EVENT_MANAGER:UnregisterForEvent(ZAB.id, EVENT_ADD_ON_LOADED)
        ZAB.InitializeLanguageStrings()
        ZAB.InitializeSettings()
        InitializeSubAddons()
    end
end)


-- Helper Debug function
function ZAB.Debug(label, message, vars)
    if not ZAB.Settings.debug then
        return
    end

    local params = ""

    if vars then
        local i = 1
        for key in pairs(vars) do
            local val = "nil"
            pcall(function() val = tostring(vars[key]) end)
            params = params .. string.format("|cA9B7C6%s|r|cA9B7C6=|r|c88DD88%s|r ", tostring(key), val)
            i = i + 1
        end
    end

    d(string.format("|c808080[%s:%s]|r |cFFFFFF%s|r %s", "ZAB", label, message, params))
end