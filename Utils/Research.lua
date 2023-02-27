-- A namespace for our sub addon
local Self = {
    maxQualityLevel = 4
}
ZAB.ResearchUtils = Self

local LABEL = "ResearchUtils"
local ID = "ZAB_" .. LABEL


-- A filter for the items to only return items meeting specified conditions
local function ItemFilter(craftSkill)
    return function(itemData)
        -- Generic conditions
        if itemData.isPlayerLocked or itemData.quality > Self.maxQualityLevel then
            return false
        end

        -- Can only research weapons and armor
        if not (itemData.itemType == ITEMTYPE_WEAPON or itemData.itemType == ITEMTYPE_ARMOR) then
            return false
        end

        local itemCraftingType, _ = GetRearchLineInfoFromRetraitItem(itemData.bagId, itemData.slotIndex)

        -- If item is for a different crafting skill
        if itemCraftingType ~= craftSkill then
            return false
        end

        local link = GetItemLink(itemData.bagId, itemData.slotIndex, LINK_STYLE_BRACKETS)

        local canResearch = CanItemLinkBeTraitResearched(link)

        if canResearch then
            ZAB.Debug(LABEL, "Candidate", { link = link })
        end

        return canResearch
    end
end


-- Get items that can be researched, returns empty if max research already in progress
function Self.GetResearchCandidates(craftSkill)
    local maxResearches = GetMaxSimultaneousSmithingResearch(craftSkill)

    local activeResearches = 0
    for i = 1, GetNumSmithingResearchLines(craftSkill) do
        local _, _, numTraits, _ = GetSmithingResearchLineInfo(craftSkill, i)

        for t = 1, numTraits do
            local _, timeRemainingSecs = GetSmithingResearchLineTraitTimes(craftSkill, i, t)
            if timeRemainingSecs then
                activeResearches = activeResearches + 1
            end
        end
    end

    if activeResearches >= maxResearches then
        return { maxResearchesInProgress = true }
    end

    return SHARED_INVENTORY:GenerateFullSlotData(ItemFilter(craftSkill), BAG_BANK, BAG_BACKPACK, BAG_SUBSCRIBER_BANK)
end