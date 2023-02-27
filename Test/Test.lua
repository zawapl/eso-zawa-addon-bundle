Self = {}
ZAB.Test = Self

local LABEL = "Test"
local ID = "ZAB_" .. LABEL

function Self.OnButtonPressA()
    ZAB.Debug(LABEL, "OnButtonPressA")
    ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NEGATIVE_CLICK, "OnButtonPressA")
end

function Self.OnButtonPressB()
    ZAB.Debug(LABEL, "OnButtonPressB")
    ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NEGATIVE_CLICK, "OnButtonPressB")
end