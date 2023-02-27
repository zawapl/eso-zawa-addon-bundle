-- Default strings to use in the UI: en
ZAB.lang = {
    SETTINGS_ADDON_NAME = "ZawaPL Addon Bundle",

    NOTIFICATION_ICONS_HEADER = "Notification Icons",
    NOTIFICATION_ICONS_ENABLED = "Visible",
    NOTIFICATION_ICONS_SHOW_ALL_ICONS = "Show all icons",
    NOTIFICATION_ICONS_REFRESH_ICONS = "Refresh icons",
    NOTIFICATION_ICONS_VERTICAL = "Vertical",
    NOTIFICATION_ICON_ALIGNMENT = "Alignment",
    NOTIFICATION_ICON_ALIGNMENT_TOP = "TOP",
    NOTIFICATION_ICON_ALIGNMENT_LEFT = "LEFT",
    NOTIFICATION_ICON_ALIGNMENT_RIGHT = "RIGHT",
    NOTIFICATION_ICON_ALIGNMENT_BOTTOM = "BOTTOM",
    NOTIFICATION_ICON_ALIGNMENT_TOP_LEFT = "TOP_LEFT",
    NOTIFICATION_ICON_ALIGNMENT_TOP_RIGHT = "TOP_RIGHT",
    NOTIFICATION_ICON_ALIGNMENT_BOTTOM_LEFT = "BOTTOM_LEFT",
    NOTIFICATION_ICON_ALIGNMENT_BOTTOM_RIGHT = "BOTTOM_RIGHT",

    MOUNT_TRAINING_HEADER = "Riding Skill Training",
    MOUNT_TRAINING_REMINDER_NAME = "Riding Skill Training Reminder",
    MOUNT_TRAINING_REMINDER_TT = "Show icon when it's possible to train a riding skill",
    MOUNT_TRAINING_REMINDER_ALERT = "Riding skill training is available at the Stablemaster",
    MOUNT_TRAINING_AUTOMATED = "Automated Riding Skill Training",
    MOUNT_TRAINING_AUTOMATED_TT = "Riding skills will automatically be purchased upon visiting the Stablemaster",
    MOUNT_TRAINING_AUTOMATED_PRIORITY = "Training Priority",
    MOUNT_TRAINING_AUTOMATED_PRIORITY_TT = "The order in which skills will be prioritized when training automatically",

    DEBUG_MODE = "Debug Mode",
    DEBUG_MODE_TT = "Toggle debug mode which provides logs in the chat",

    RESEARCH_REMINDER = "Item trait research available"
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
