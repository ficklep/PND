--[[SND Metadata]]
author: PM
version: 0.1.0
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
    local e = 0

    for f in luanet.each(Svc.Objects)do
        if f.ObjectKind.value__ == 1 then
            local g = b.Distance(c, f.Position)

            if g <= d then
                e = e + 1
            end
        end
    end

    yield(string.format('/e Players queued for Forked Tower: %d', e))
end

OCTowerQueue()
