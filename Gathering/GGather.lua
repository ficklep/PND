--[=====[
[[SND Metadata]]
author: PM
version: 0.1.1
description: Uses GatherBuddy's /gather command with the contents of the clipboard text
[[End Metadata]]
--]=====]

local function gGather()
    local a = System.GetClipboardText()

    yield('/gather ' .. tostring(a))
end

gGather()
