--[[SND Metadata]]

--[[End Metadata]]

local function gGather()
    local a = System.GetClipboardText()

    yield('/gather ' .. tostring(a))
end

gGather()
