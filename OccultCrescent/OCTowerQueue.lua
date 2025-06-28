--[[SND Metadata]]
author: PM
version: 0.2.0
description: Counts the number of players in the teleporter for Forked Tower
--[[End Metadata]]

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

import'System.Numerics'

local b = a.load'a'
local c = Vector2(63, 4)
local d = 20

local function OCTowerQueue()
    local e = Svc.ClientState.TerritoryType == 1252

    if not e then
        yield'/e Not currently in South Horn'

        return
    end

    local f = 0

    for g in luanet.each(Svc.Objects)do
        if g.ObjectKind.value__ == 1 then
            local h = b.Distance(c, g.Position)

            if h <= d then
                f = f + 1
            end
        end
    end

    yield(string.format('/e Players queued for Forked Tower: %d', f))
end

OCTowerQueue()
