--[=====[
[[SND Metadata]]
author: PM
version: 0.4.2
description: Counts the number of players in the teleporter for Forked Tower
[[End Metadata]]
--]=====]

import'System.Numerics'

local a = Vector3(63, 126.5, 4)
local b = 20

local function OCTowerQueue()
    local c = Svc.ClientState.TerritoryType == 1252

    if not c then
        Svc.Chat:Print'Not currently in south horn'

        return
    end
    if Vector3.Distance(Player.Entity.Position, a) > 100 then
        Svc.Chat:Print'Too far from teleporter'

        return
    end

    local d = 0

    for e in luanet.each(Svc.Objects)do
        if e.ObjectKind.value__ == 1 then
            local f = Vector3.Distance(a, e.Position)

            if f <= b then
                d = d + 1
            end
        end
    end

    Svc.Chat:Print(string.format('Players queued for Forked Tower: %d', d))
end

OCTowerQueue()
