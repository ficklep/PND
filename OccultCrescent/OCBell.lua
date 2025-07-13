--[=====[
[[SND Metadata]]
author: PM
version: 0.5.0
description: Applies geomancer bell buffs and switches back to the class the script was ran on
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
            local c = not Player.Entity.IsMounted
            local d = not Player.Entity.IsInCombat
            local e = Svc.ClientState.TerritoryType == 1252

            return d and c and e
        end

        return b
    end
    function a.b()
        local function ErrorToast(b)
            Svc.Toasts:ShowError(b)
        end

        return ErrorToast
    end
    function a.c()
        local b = a.load'b'

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

local b = a.load'a'
local c = a.load'c'

local function ocBell()
    if not b.canChangePhJob() then
        c('This can not be used at this time', true)

        return
    end

    local d = b.getOcJob()

    yield'/phantomjob geomancer'
    yield'/wait 1'

    if InstancedContent.OccultCrescent.OccultCrescentState.CurrentSupportJob ~= 7 then
        c('Unable to switch to Ph. geomancer', true)

        return
    end

    yield'/action "Phantom Action III"'
    yield'/wait 1'
    yield'/action "Phantom Action I"'
    yield'/wait 1'
    yield('/phantomjob ' .. d)
end

ocBell()
