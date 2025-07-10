--[=====[
[[SND Metadata]]
author: PM
version: 0.5.2
description: Applies all memory crystal buffs and returns to the class the script was ran on
configs:
  enableBard:
    description: Enable Ph. Bard's buff Romeo's Ballad (Phantom EXP earned through battle is increased)
    type: bool
    default: true
  enableKnight:
    description: Enable Ph. Knight's buff Enduring Fortitude (Damage taken is reduced)
    type: bool
    default: true
  enableMonk:
    description: Enable Ph. Monk's buff Fleetfooted (Movement speed is increased)
    type: bool
    default: true
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

import'System.Numerics'

local b = a.load'a'

OCJobBuffs = {
    {
        id = 1,
        name = 'Knight',
        enabled = Config.Get'enableKnight',
        action = 2,
        level = 2,
    },
    {
        id = 3,
        name = 'Monk',
        enabled = Config.Get'enableMonk',
        action = 3,
        level = 3,
    },
    {
        id = 6,
        name = 'Bard',
        enabled = Config.Get'enableBard',
        action = 2,
        level = 2,
    },
}

local function ocBuffs()
    local c = b.getOcJob()
    local d = false

    if not b.canChangePhJob() then
        yield'/e This can not be used at this time'

        return
    end

    for e in luanet.each(Svc.Objects)do
        if e.DataId == 2007457 then
            local f = Vector3.Distance(e.Position, Entity.Player.Position)

            if f < 4.8 then
                d = true
            end
        end
    end

    if not d then
        yield'/e Too far from a knowledge crystal to apply buffs.'

        return
    end

    local e = InstancedContent.OccultCrescent.OccultCrescentState.SupportJobLevels

    for f, g in ipairs(OCJobBuffs)do
        if g.enabled and (e[g.id] >= g.level) then
            yield('/phantomjob ' .. g.name)
            yield'/wait 2'
            yield('/action "Phantom Action ' .. string.rep('I', g.action) .. '"')
            yield'/wait 3'
        end
    end

    yield('/phantomjob ' .. c)
end

ocBuffs()
