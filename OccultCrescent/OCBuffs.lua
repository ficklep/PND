--[=====[
[[SND Metadata]]
author: PM
version: 0.6.0
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
        local function ErrorToast(b)
            Svc.Toasts:ShowError(b)
        end

        return ErrorToast
    end
    function a.b()
        local b = a.load'a'

        local function ErrorLog(c, d)
            d = d or false

            Svc.Chat:PrintError(c, 'PND', 58)
            Dalamud.Log(string.format('[PND] [ERROR] %s', c))

            if d then
                b(c)
            end
        end

        return ErrorLog
    end
    function a.c()
        local b = {}

        function b.getOcJob()
            local c = InstancedContent.OccultCrescent.OccultCrescentState.CurrentSupportJob
            local d = Excel.GetRow('MKDSupportJob', c).Unknown1
            local e = string.gsub(d, 'Ph. ', '')

            return e
        end
        function b.canChangePhJob()
            local c = not Player.Entity.IsMounted
            local d = not Player.Entity.IsInCombat
            local e = Svc.ClientState.TerritoryType == 1252

            return d and c and e
        end

        return b
    end
end

local b = a.load'b'

import'System.Numerics'

local c = a.load'c'

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
    local d = c.getOcJob()
    local e = false

    if not c.canChangePhJob() then
        b('This can not be used at this time', true)

        return
    end

    for f in luanet.each(Svc.Objects)do
        if f.DataId == 2007457 then
            local g = Vector3.Distance(f.Position, Entity.Player.Position)

            if g < 4.8 then
                e = true
            end
        end
    end

    if not e then
        b('Too far from a knowledge crystal to apply buffs.', true)

        return
    end

    local f = InstancedContent.OccultCrescent.OccultCrescentState.SupportJobLevels

    for g, h in ipairs(OCJobBuffs)do
        if h.enabled and (f[h.id] >= h.level) then
            yield('/phantomjob ' .. h.name)
            yield'/wait 2'
            yield('/action "Phantom Action ' .. string.rep('I', h.action) .. '"')
            yield'/wait 3'
        end
    end

    yield('/phantomjob ' .. d)
end

ocBuffs()
