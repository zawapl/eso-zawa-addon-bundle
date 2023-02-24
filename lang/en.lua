-- Default strings to use in the UI: en
ZAB.lang = {
    SETTINGS_ADDON_NAME = "Zawa Addon Bundle",

    MOUNT_TRAINING_HEADER = "Riding Skill Training",
    MOUNT_TRAINING_REMINDER_NAME = "Riding Skill Training Reminder",
    MOUNT_TRAINING_REMINDER_TT = "Show icon when it's possible to train a riding skill",
    MOUNT_TRAINING_AUTOMATED = "Automated Riding Skill Training",
    MOUNT_TRAINING_AUTOMATED_TT = "Riding skills will automatically be purchased upon visiting the Stablemaster",
    MOUNT_TRAINING_AUTOMATED_PRIORITY = "Training Priority",
    MOUNT_TRAINING_AUTOMATED_PRIORITY_TT = "The order in which skills will be prioritized when training automatically",

    DEBUG_MODE = "Debug Mode",
    DEBUG_MODE_TT = "Toggle debug mode which provides logs in the chat",
}


-- Other languages can implement implement LangReplace to produce strings to replace in original ZAB.lang
function ZAB.LangReplace()
    return {}
end


function ZAB.InitializeLanguageStrings()
    for key in pairs(ZAB.LangReplace()) do
        ZAB.lang[key] = ZAB.langReplace[key]
    end
end
