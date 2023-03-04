-- A namespace for our sub addon
local Self = {
    maxQualityLevel = 4
}
ZAB.ResearchUtils = Self

local LABEL = "ResearchUtils"
local ID = "ZAB_" .. LABEL

-- TODO exclude item types that are currently being researched

-- A filter for the items to only return items meeting specified conditions
local function ItemFilter(craftSkill, activeResearchLines)
    return function(itemData)

        -- Generic conditions
        if itemData.isPlayerLocked or itemData.quality > Self.maxQualityLevel then
            return false
        end

        -- Can only research weapons and armor
        if not (itemData.itemType == ITEMTYPE_WEAPON or itemData.itemType == ITEMTYPE_ARMOR) then
            return false
        end

        local itemCraftingType, researchLineName = GetRearchLineInfoFromRetraitItem(itemData.bagId, itemData.slotIndex)

        -- If item is for a different crafting skill
        if itemCraftingType ~= craftSkill then
            return false
        end

        -- If item type is currently being researched
        if activeResearchLines[researchLineName] then
            return false
        end

        local link = GetItemLink(itemData.bagId, itemData.slotIndex, LINK_STYLE_BRACKETS)
        local hasSet, setName, numBonuses, numNormalEquipped, maxEquipped, setId, numPerfectedEquipped = GetItemLinkSetInfo(link)

        if hasSet and not ZAB.Settings.researchAutomator.researchableSets[setId] then
            return false
        end

        local canResearch = CanItemLinkBeTraitResearched(link)

        if canResearch then
            ZAB.Debug(LABEL, "Candidate", { link = link })
            --ZAB.Debug(LABEL, "Candidate itemData", itemData)
        end

        itemData.itemCraftingType = itemCraftingType
        itemData.researchLineName = researchLineName
        itemData.hasSet = hasSet
        itemData.setId = setId
        itemData.traitType = GetItemLinkTraitType(link)
        itemData.link = link

        return canResearch
    end
end


-- Get items that can be researched, returns empty if max research already in progress
function Self.GetResearchCandidates(craftSkill)
    local maxResearches = GetMaxSimultaneousSmithingResearch(craftSkill)

    local activeResearchLines = {}
    local activeResearches = 0
    for i = 1, GetNumSmithingResearchLines(craftSkill) do
        local researchLineName, _, numTraits, _ = GetSmithingResearchLineInfo(craftSkill, i)

        for t = 1, numTraits do
            local _, timeRemainingSecs = GetSmithingResearchLineTraitTimes(craftSkill, i, t)
            if timeRemainingSecs then
                activeResearches = activeResearches + 1
                activeResearchLines[researchLineName] = true
            end
        end
    end

    ZAB.Debug(LABEL, "Items being researched", activeResearchLines)

    if activeResearches >= maxResearches then
        return { maxResearchesInProgress = true }
    end

    return SHARED_INVENTORY:GenerateFullSlotData(ItemFilter(craftSkill, activeResearchLines), BAG_BANK, BAG_BACKPACK, BAG_SUBSCRIBER_BANK)
end


-- Create a submenu in the settings to contain a list of sets to allow/disallow for use in researching
function Self.BuildSetSettings()
    local sets = {}

    local setId = GetNextItemSetCollectionId()

    while setId do
        local setName = GetItemSetName(setId)

        sets[#sets + 1] = { id = setId, name = setName}

        setId = GetNextItemSetCollectionId(setId)
    end

    table.sort(sets, function(a,b) return a.name < b.name end)

    local controls = {
        {
            type = "button",
            name = "Select all",
            width = "half",
            func = function()
                for i, _ in pairs(ZAB.Settings.researchAutomator.researchableSets) do
                    ZAB.Settings.researchAutomator.researchableSets[i] = true
                end
            end,
        },
        {
            type = "button",
            name = "Deselect all",
            width = "half",
            func = function()
                for i, _ in pairs(ZAB.Settings.researchAutomator.researchableSets) do
                    ZAB.Settings.researchAutomator.researchableSets[i] = false
                end
            end,
        }
    }

    for i,set in ipairs(sets) do
        local getFunc = function()
            return ZAB.Settings.researchAutomator.researchableSets[set.id]
        end

        local setFunc = function(newVal)
            ZAB.Settings.researchAutomator.researchableSets[set.id] = newVal
        end

        ZAB.Settings.researchAutomator.researchableSets[set.id] = ZAB.Settings.researchAutomator.researchableSets[set.id] or false

        table.insert(controls, {
            type = "checkbox",
            name = set.name,
            tooltip = "",
            getFunc = getFunc,
            setFunc = setFunc,
            default = ZAB.Settings.researchAutomator.researchableSets[set.id],
            width = "full",
        })
    end

    return {
        type = "submenu",
        name = "Sets",
        tooltip = "My submenu tooltip", --(optional)
        controls = controls
    }
end