-- A namespace for our sub addon
local Self = {
    maxQualityLevel = 4
}
ZAB.ResearchAutomator = Self

local LABEL = "ResearchAutomator"
local ID = "ZAB_" .. LABEL

local function ChooseBetterCandidate(itemA, itemB)
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

    ZAB.Debug(LABEL, "Comparing quality", { itemA = itemA.quality, itemB = itemB.quality })
    if itemA.quality < itemB.quality then
        return itemA
    elseif itemA.quality > itemB.quality then
        return itemB
    end

    return itemA
end

local function LogSetDetails(item)
    local link = GetItemLink(item.bagId, item.slotIndex, LINK_STYLE_BRACKETS)
    local hasSet, setName, numBonuses, numNormalEquipped, maxEquipped, setId, numPerfectedEquipped = GetItemLinkSetInfo(link)
    ZAB.Debug(LABEL, "Item Set info", { setId = setId, setName = setName, link = link })
end

local function OnCraftingStationInteract(_eventCode, craftSkill, _sameStation)
    local allItems = ZAB.ResearchUtils.GetResearchCandidates(craftSkill)

    if allItems.maxResearchesInProgress then
        ZAB.Debug(LABEL, "Max researches in progress")
    elseif #allItems > 0 then
        local bestItem = allItems[1]
        LogSetDetails(bestItem)
        for i = 2, #allItems do
            local otherItem = allItems[i]
            LogSetDetails(otherItem)
            bestItem = ChooseBetterCandidate(bestItem, otherItem)
        end

        local link = GetItemLink(bestItem.bagId, bestItem.slotIndex, LINK_STYLE_BRACKETS)
        ZAB.Debug(LABEL, "Best item", { link = link })
        -- ResearchSmithingTrait(number Bag bagId, number slotIndex)
    else
        ZAB.Debug(LABEL, "No candidates found")
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