-- A namespace for our sub addon
local Self = {
    canResearchBlacksmithing = false,
    canResearchClothier = false,
    canResearchWoodworking = false,
    canResearchJewelery = false,
}
ZAB.ResearchReminder = Self

local LABEL = "ResearchReminder"
local ID = "ZAB_" .. LABEL


local function UpdateIcon()
    local isVisible = Self.canResearchBlacksmithing or Self.canResearchClothier or Self.canResearchWoodworking or Self.canResearchJewelery
    ZAB.Debug(LABEL, "UpdateIcon", { isVisible = isVisible })
    ZAB.NotificationIcons.SetVisible("/esoui/art/crafting/smithing_tabicon_research_up.dds", isVisible)
    if isVisible then
        ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NEGATIVE_CLICK, ZAB.lang.RESEARCH_REMINDER)
    end
end


local function UpdateCanResearch(craftingSkillType, canResearch)
    if craftingSkillType == CRAFTING_TYPE_BLACKSMITHING then
        local prevVal = Self.canResearchBlacksmithing
        Self.canResearchBlacksmithing = canResearch
        return prevVal ~= canResearch
    elseif craftingSkillType == CRAFTING_TYPE_CLOTHIER then
        local prevVal = Self.canResearchClothier
        Self.canResearchClothier = canResearch
        return prevVal ~= canResearch
    elseif craftingSkillType == CRAFTING_TYPE_WOODWORKING then
        local prevVal = Self.canResearchWoodworking
        Self.canResearchWoodworking = canResearch
        return prevVal ~= canResearch
    elseif craftingSkillType == CRAFTING_TYPE_JEWELRYCRAFTING then
        canResearch = canResearch and IsESOPlusSubscriber()
        local prevVal = Self.canResearchJewelery
        Self.canResearchJewelery = canResearch
        return prevVal ~= canResearch
    end
end


local function CanResearch(craftingSkillType)
    if craftingSkillType == CRAFTING_TYPE_BLACKSMITHING then
        return Self.canResearchBlacksmithing
    elseif craftingSkillType == CRAFTING_TYPE_CLOTHIER then
        return Self.canResearchClothier
    elseif craftingSkillType == CRAFTING_TYPE_WOODWORKING then
        return Self.canResearchWoodworking
    elseif craftingSkillType == CRAFTING_TYPE_JEWELRYCRAFTING then
        return Self.canResearchJewelery
    end
end



local function OnResearchUpdate(_eventCode, craftingSkillType)
    ZAB.Debug(LABEL, "OnResearchUpdate", { craftingSkillType = craftingSkillType })
    local researchCandidates = ZAB.ResearchUtils.GetResearchCandidates(craftingSkillType)
    if UpdateCanResearch(craftingSkillType, #researchCandidates > 0) then
        UpdateIcon()
    end
end


local function OnLootRecieved(eventCode, receivedBy, itemName, quantity, soundCategory, lootType, isSelf, isPickpocketLoot, questItemIcon, itemId, isStolen)
    if isSelf then
        local craftingSkillType = GetItemLinkCraftingSkillType(itemName)
        if not CanResearch(craftingSkillType) then
            OnResearchUpdate(eventCode, craftingSkillType)
        end
    end
end


-- Enable/disable research automator bar
function Self.SetEnabled(isEnabled)
    ZAB.Debug(LABEL, "SetEnabled", { isEnabled = isEnabled })

    if isEnabled then
        OnResearchUpdate(nil, CRAFTING_TYPE_BLACKSMITHING)
        OnResearchUpdate(nil, CRAFTING_TYPE_CLOTHIER)
        OnResearchUpdate(nil, CRAFTING_TYPE_WOODWORKING)
        OnResearchUpdate(nil, CRAFTING_TYPE_JEWELRYCRAFTING)
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_SMITHING_TRAIT_RESEARCH_COMPLETED, OnResearchUpdate)
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_SMITHING_TRAIT_RESEARCH_STARTED, OnResearchUpdate)
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_LOOT_RECEIVED , OnLootRecieved)
    else
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_SMITHING_TRAIT_RESEARCH_COMPLETED)
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_SMITHING_TRAIT_RESEARCH_STARTED)
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_LOOT_RECEIVED )
        Self.canResearchBlacksmithing = false
        UpdateIcon()
    end
end