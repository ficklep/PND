--[=====[
[[SND Metadata]]
author: PM
version: 0.5.0
description: Counts the number of players in the teleporter for Forked Tower
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
        local function NormalToast(b)
            Svc.Toasts:ShowNormal(b)
        end

        return NormalToast
    end
    function a.b()
        local b = a.load'a'

        local function NormalLog(c, d)
            d = d or false

            Svc.Chat:Print(c, 'PND', 58)
            Dalamud.Log(string.format('[PND] [INFO] %s', c))

            if d then
                b(c)
            end
        end

        return NormalLog
    end
    function a.c()
        local function ErrorToast(b)
            Svc.Toasts:ShowError(b)
        end

        return ErrorToast
    end
    function a.d()
        local b = a.load'c'

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
end

local b = a.load'b'
local c = a.load'd'

import'System.Numerics'

local d = Vector3(63, 126.5, 4)
local e = 20

local function OCTowerQueue()
    local f = Svc.ClientState.TerritoryType == 1252

    if not f then
        c('Not currently in south horn', true)

        return
    end
    if Vector3.Distance(Player.Entity.Position, d) > 100 then
        c('Too far from teleporter', true)

        return
    end

    local g = 0

    for h in luanet.each(Svc.Objects)do
        if h.ObjectKind.value__ == 1 then
            local i = Vector3.Distance(d, h.Position)

            if i <= e then
                g = g + 1
            end
        end
    end

    b(string.format('Players queued for Forked Tower: %d', g), true)
end

OCTowerQueue()
