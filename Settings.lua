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
            disabled = function()
                return not ZAB.RidingSkillAutoTrainer.IsEnabled()
            end,
            default = ZAB.Settings.ridingSkillTraining.skillPriorityListId,
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
        }
    }

    LibAddonMenu2:RegisterOptionControls(ZAB.id, optionsTable)

    ZAB.Settings = settings
end