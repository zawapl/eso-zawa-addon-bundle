-- A namespace for our sub addon
local NotificationIcons = {}

ZAB.NotificationIcons = NotificationIcons


function NotificationIcons.SetVisible(element, isVisible)
    if element:IsHidden() == isVisible then
        element:SetHidden(not isVisible)
        if isVisible then
            element:SetHeight(64)
        else
            element:SetHeight(0)
        end
    end
end