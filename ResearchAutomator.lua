-- A namespace for our sub addon
local Self = {
    maxQualityLevel = 4
}
ZAB.ResearchAutomator = Self

local LABEL = "ResearchAutomator"
local ID = "ZAB_" .. LABEL

local function ChooseBetterCandidate(itemA, itemB)
    ZAB.Debug(LABEL, "Comparing", { itemA = itemA.link, itemB = itemB.link })

    -- TODO First check if trait is being prioritised

    -- TODO Then check if item type is being prioritized

    ZAB.Debug(LABEL, "Comparing quality", { itemA = itemA.quality, itemB = itemB.quality })
    if itemA.quality < itemB.quality then
        return itemA
    elseif itemA.quality > itemB.quality then
        return itemB
    end

    ZAB.Debug(LABEL, "Comparing requiredChampionPoints", { itemA = itemA.requiredChampionPoints, itemB = itemB.requiredChampionPoints })
    if itemA.requiredChampionPoints < itemB.requiredChampionPoints then
        return itemA
    elseif itemA.requiredChampionPoints > itemB.requiredChampionPoints then
        return itemB
    end

    ZAB.Debug(LABEL, "Comparing requiredLevel", { itemA = itemA.requiredLevel, itemB = itemB.requiredLevel })
    if itemA.requiredLevel < itemB.requiredLevel then
        return itemA
    elseif itemA.requiredLevel > itemB.requiredLevel then
        return itemB
    end

    ZAB.Debug(LABEL, "Comparing hasSet", { itemA = itemA.hasSet, itemB = itemB.hasSet })
    if not itemA.hasSet and itemB.hasSet then
        return itemA
    elseif not itemB.hasSet and itemA.hasSet then
        return itemB
    end

    ZAB.Debug(LABEL, "Comparing traitAlts", { itemA = itemA.traitAlts, itemB = itemB.traitAlts })
    if itemA.traitAlts > itemB.traitAlts then
        return itemA
    elseif itemA.traitAlts < itemB.traitAlts then
        return itemB
    end

    return itemA
end

local function AddTraitAlts(allItems)
    local results = {}

    for i = 1, #allItems do
        local item = allItems[i]

        local researchLineName = item.researchLineName
        local trait = item.traitType

        if not results[researchLineName] then
            results[researchLineName] = {}
        end

        if not results[researchLineName][trait] then
            results[researchLineName][trait] = 0
        end

        results[researchLineName][trait] = results[researchLineName][trait] + 1
    end

    for i = 1, #allItems do
        local item = allItems[i]

        local researchLineName = item.researchLineName
        local trait = item.traitType

        item.traitAlts = 0
        item.traitAlts = results[researchLineName][trait]
    end
end

local function OnCraftingStationInteract(_eventCode, craftSkill, _sameStation)
    local allItems = ZAB.ResearchUtils.GetResearchCandidates(craftSkill)

    AddTraitAlts(allItems)

    if allItems.maxResearchesInProgress then
        ZAB.Debug(LABEL, "Max researches in progress")
    elseif #allItems == 0 then
        ZAB.Debug(LABEL, "No candidates found")
    else
        local bestItem = allItems[1]
        for i = 2, #allItems do
            local otherItem = allItems[i]
            bestItem = ChooseBetterCandidate(bestItem, otherItem)
        end

        --local link = GetItemLink(bestItem.bagId, bestItem.slotIndex, LINK_STYLE_BRACKETS)
        ZAB.Debug(LABEL, "Best item", { link = bestItem.link })
        -- ResearchSmithingTrait(number Bag bagId, number slotIndex)
    end
end


-- Enable/disable research automator bar
function Self.SetEnabled(isEnabled)
    ZAB.Debug(LABEL, "SetEnabled", { isEnabled = isEnabled })
    ZAB.Settings.researchAutomator.enabled = isEnabled

    if isEnabled then
        EVENT_MANAGER:RegisterForEvent(ID, EVENT_CRAFTING_STATION_INTERACT, OnCraftingStationInteract)
    else
        EVENT_MANAGER:UnregisterForEvent(ID, EVENT_CRAFTING_STATION_INTERACT)
    end
end