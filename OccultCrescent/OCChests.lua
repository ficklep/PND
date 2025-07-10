--[=====[
[[SND Metadata]]
author: PM
version: 0.3.0
description: Checks for chests in OC
[[End Metadata]]
--]=====]

local a

a = {
    cache = {},
    load = function(b)
        if not a.cache[b] then
            a.cache[b] = {
                c = a[b](),
            }
        end

        return a.cache[b].c
    end,
}

do
    function a.a()
        local b = {}

        function b.getOcJob()
            local c = InstancedContent.OccultCrescent.OccultCrescentState.CurrentSupportJob
            local d = Excel.GetRow('MKDSupportJob', c).Unknown1
            local e = string.gsub(d, 'Ph. ', '')

            return e
        end
        function b.canChangePhJob()
            local c = not Player.Entity.IsInCombat
            local d = not Player.Entity.IsInCombat
            local e = Svc.ClientState.TerritoryType == 1252

            return d and c and e
        end

        return b
    end
end

local b = a.load'a'

local function ocChests()
    if not b.canChangePhJob() then
        yield'/e This can not be used at this time'

        return
    end

    local c = b.getOcJob()

    yield'/phantomjob freelancer'
    yield'/wait 2'
    yield'/action "Phantom Action II"'
    yield'/wait 2'
    yield('/phantomjob ' .. c)
end

ocChests()
