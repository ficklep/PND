--[=====[
[[SND Metadata]]
author: PM
version: 0.5.0
description: Applies all memory crystal buffs and returns to the class the script was ran on
configs:
  enableBard:
    description: Enable Ph. Bard's buff Romeo's Ballad (Phantom EXP earned through battle is increased)
    type: bool
    default: true
    required: true
  enableKnight:
    description: Enable Ph. Bard's buff Enduring Fortitude (Damage taken is reduced)
    type: bool
    default: true
    required: true
  enableMonk:
    description: Enable Ph. Monk's buff Fleetfooted (Movement speed is increased)
    type: bool
    default: true
    required: true
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
    function a.b()
        local b = {}

        function b.to2D(c)
            if c.Z ~= nil then
                return {
                    X = c.X,
                    Y = c.Z,
                }
            end

            return {
                X = c.X,
                Y = c.Y,
            }
        end
        function b.Distance(c, d)
            local e = b.to2D(c)
            local f = b.to2D(d)

            return math.sqrt(((e.X - f.X) ^ 2) + (e.Y - f.Y) ^ 2)
        end

        return b
    end
end

local b = a.load'a'
local c = a.load'b'

OCJobBuffs = {
    {
        name = 'Knight',
        enabled = Config.Get'enableKnight',
        action = 2,
    },
    {
        name = 'Monk',
        enabled = Config.Get'enableMonk',
        action = 3,
    },
    {
        name = 'Bard',
        enabled = Config.Get'enableBard',
        action = 2,
    },
}

local function ocBuffs()
    local d = b.getOcJob()
    local e = false

    if not b.canChangePhJob() then
        yield'/e This can not be used at this time'

        return
    end

    for f in luanet.each(Svc.Objects)do
        if f.DataId == 2007457 then
            local g = c.Distance(f.Position, Entity.Player.Position)

            if g < 4.8 then
                e = true
            end
        end
    end

    if not e then
        yield'/e Too far from a knowledge crystal to apply buffs.'

        return
    end

    for f, g in ipairs(OCJobBuffs)do
        if g.enabled then
            yield('/phantomjob ' .. g.name .. ' <wait.2-4>')
            yield('/action "Phantom Action ' .. string.rep('I', g.action) .. '" <wait.2-3>')
        end
    end

    yield('/phantomjob ' .. d)
end

ocBuffs()
