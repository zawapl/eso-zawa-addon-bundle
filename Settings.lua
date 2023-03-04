local LABEL = "Settings"
local ID = "ZAB_" .. LABEL

local function Not(func)
    return function()
        return not func()
    end
end

-- Initialize settings and saved vars for the whole addon
function ZAB.InitializeSettings()
    local saved_vars_name = "ZAB_Data"

    local settings = LibSavedVars
            :NewAccountWide(saved_vars_name, "Account", ZAB.Settings)
            :AddCharacterSettingsToggle(saved_vars_name, "Characters")
            :MigrateFromAccountWide({ name = saved_vars_name })
            :EnableDefaultsTrimming()

    local panelData = {
        type = "panel",
        name = ZAB.lang.SETTINGS_ADDON_NAME,
        displayName = ZAB.lang.SETTINGS_ADDON_NAME,
        author = ZAB.author,
        version = ZAB.version,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    LibAddonMenu2:RegisterAddonPanel(ZAB.id, panelData)

    local optionsTable = {
        settings:GetLibAddonMenuAccountCheckbox(),
        -- NotificationIcons Settings
        {
            type = "header",
            name = ZAB.lang.NOTIFICATION_ICONS_HEADER,
            width = "full",
        },
        {
            type = "checkbox",
            name = ZAB.lang.NOTIFICATION_ICONS_ENABLED,
            tooltip = "",
            getFunc = ZAB.NotificationIcons.IsEnabled,
            setFunc = ZAB.NotificationIcons.SetEnabled,
            default = ZAB.Settings.notificationIcons.enabled,
            width = "full",
        },
        {
            type = "checkbox",
            name = ZAB.lang.NOTIFICATION_ICONS_VERTICAL,
            tooltip = "",
            getFunc = ZAB.NotificationIcons.IsVertical,
            setFunc = ZAB.NotificationIcons.SetVertical,
            default = ZAB.Settings.notificationIcons.vertical,
            disabled = Not(ZAB.NotificationIcons.IsEnabled),
            width = "full",
        },
        {
            type = "dropdown",
            name = ZAB.lang.NOTIFICATION_ICON_ALIGNMENT,
            tooltip = "",
            getFunc = ZAB.NotificationIcons.GetAlignment,
            setFunc = ZAB.NotificationIcons.SetAlignment,
            choices = ZAB.NotificationIcons.GetAlignmentLabels(),
            choicesValues = ZAB.NotificationIcons.GetAlignmentValues(),
            default = ZAB.Settings.notificationIcons.alignment,
            disabled = Not(ZAB.NotificationIcons.IsEnabled),
            width = "full",
        },
        {
            type = "editbox",
            name = "x offset",
            tooltip = "",
            getFunc = ZAB.NotificationIcons.GetXOffset,
            setFunc = ZAB.NotificationIcons.SetXOffset,
            default = ZAB.Settings.notificationIcons.xOffset,
            disabled = Not(ZAB.NotificationIcons.IsEnabled),
            isMultiline = false,
            width = "full",
        },
        {
            type = "editbox",
            name = "y offset",
            tooltip = "",
            getFunc = ZAB.NotificationIcons.GetYOffset,
            setFunc = ZAB.NotificationIcons.SetYOffset,
            default = ZAB.Settings.notificationIcons.yOffset,
            disabled = Not(ZAB.NotificationIcons.IsEnabled),
            isMultiline = false,
            width = "full",
        },
        {
            type = "button",
            name = ZAB.lang.NOTIFICATION_ICONS_REFRESH_ICONS,
            width = "half",
            func = ZAB.NotificationIcons.RefreshIcons,
            disabled = Not(ZAB.NotificationIcons.IsEnabled),
        },
        {
            type = "button",
            name = ZAB.lang.NOTIFICATION_ICONS_SHOW_ALL_ICONS,
            width = "half",
            func = ZAB.NotificationIcons.ShowAllIcons,
            disabled = Not(ZAB.NotificationIcons.IsEnabled),
        },


        -- Mount training settings
        {
            type = "header",
            name = ZAB.lang.MOUNT_TRAINING_HEADER,
            width = "full",
        },
        {
            type = "checkbox",
            name = ZAB.lang.MOUNT_TRAINING_REMINDER_NAME,
            tooltip = ZAB.lang.MOUNT_TRAINING_REMINDER_TT,
            getFunc = ZAB.RidingSkillTrainingIcon.IsEnabled,
            setFunc = ZAB.RidingSkillTrainingIcon.SetEnabled,
            default = ZAB.Settings.ridingSkillTraining.remainderIcon,
            width = "full",
        },
        {
            type = "checkbox",
            name = ZAB.lang.MOUNT_TRAINING_AUTOMATED,
            tooltip = ZAB.lang.MOUNT_TRAINING_AUTOMATED_TT,
            getFunc = ZAB.RidingSkillAutoTrainer.IsEnabled,
            setFunc = ZAB.RidingSkillAutoTrainer.SetEnabled,
            default = ZAB.Settings.ridingSkillTraining.automated,
            width = "full",
        },
        {
            type = "dropdown",
            name = ZAB.lang.MOUNT_TRAINING_AUTOMATED_PRIORITY,
            tooltip = ZAB.lang.MOUNT_TRAINING_AUTOMATED_PRIORITY_TT,
            getFunc = ZAB.RidingSkillAutoTrainer.GetPriorityListID,
            setFunc = ZAB.RidingSkillAutoTrainer.SetPriorityListID,
            choices = ZAB.RidingSkillAutoTrainer.GetPriorityListChoiceLabels(),
            choicesValues = ZAB.RidingSkillAutoTrainer.GetPriorityListChoices(),
            default = ZAB.Settings.ridingSkillTraining.skillPriorityListId,
            disabled = Not(ZAB.RidingSkillAutoTrainer.IsEnabled),
            width = "full",
        },


        -- Research
        ZAB.ResearchUtils.BuildSetSettings(),


        -- Debug mode
        {
            type = "header",
            name = ZAB.lang.DEBUG_MODE,
            width = "full",
        },
        {
            type = "checkbox",
            name = ZAB.lang.DEBUG_MODE,
            tooltip = ZAB.lang.DEBUG_MODE_TT,
            getFunc = function()
                return ZAB.Settings.debug
            end,
            setFunc = function(newVal)
                ZAB.Settings.debug = newVal
            end,
            default = ZAB.Settings.debug,
            width = "full",
        },
        {
            type = "button",
            name = "Test Button A",
            width = "half",
            func = ZAB.Test.OnButtonPressA
        },
        {
            type = "button",
            name = "Test Button B",
            width = "half",
            func = ZAB.Test.OnButtonPressB
        }
    }

    LibAddonMenu2:RegisterOptionControls(ZAB.id, optionsTable)

    ZAB.Settings = settings
end