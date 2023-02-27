-- A namespace for our sub addon
local Self = {
    canResearchBlacksmithing = false,
    canResearchClothier = false,
    canResearchWoodworking = false,
}
ZAB.ResearchReminder = Self

local LABEL = "ResearchReminder"
local ID = "ZAB_" .. LABEL


local function UpdateIcon()
    local isVisible = Self.canResearchBlacksmithing or Self.canResearchClothier or Self.canResearchWoodworking
    ZAB.Debug(LABEL, "UpdateIcon", { isVisible = isVisible })
    ZAB.NotificationIcons.SetVisible("/esoui/art/crafting/smithing_tabicon_research_up.dds", isVisible)
    if isVisible then
        ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NEGATIVE_CLICK, ZAB.lang.RESEARCH_REMINDER)
    end
end


local function UpdateCanResearch(craftingSkillType, canResearch)
    if craftingSkillType == CRAFTING_TYPE_BLACKSMITHING then
        Self.canResearchBlacksmithing = canResearch
    elseif craftingSkillType == CRAFTING_TYPE_CLOTHIER then
        Self.canResearchClothier = canResearch
    elseif craftingSkillType == CRAFTING_TYPE_WOODWORKING then
        Self.canResearchWoodworking = canResearch
    end
end


local function OnResearchUpdate(_eventCode, craftingSkillType)
    ZAB.Debug(LABEL, "OnResearchUpdate", { craftingSkillType = craftingSkillType })
    local researchCandidates = ZAB.ResearchUtils.GetResearchCandidates(craftingSkillType)
    UpdateCanResearch(craftingSkillType, #researchCandidates > 0)
    UpdateIcon()
end


-- Enable/disable research automator bar
function Self.SetEnabled(isEnabled)
    ZAB.Debug(LABEL, "SetEnabled", { isEnabled = isEnabled })

    if isEnabled then
        OnResearchUpdate(nil, CRAFTING_TYPE_BLACKSMITHING)
        OnResearchUpdate(nil, CRAFTING_TYPE_CLOTHIER)
        OnResearchUpdate(nil, CRAFTING_TYPE_WOODWORKING)
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_SMITHING_TRAIT_RESEARCH_COMPLETED, OnResearchUpdate)
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_SMITHING_TRAIT_RESEARCH_STARTED, OnResearchUpdate)
    else
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_SMITHING_TRAIT_RESEARCH_COMPLETED)
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_SMITHING_TRAIT_RESEARCH_STARTED)
        Self.canResearchBlacksmithing = false
        UpdateIcon()
    end
end