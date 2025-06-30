--[[SND Metadata]]
author: PM
version: 0.1.2
description: Switches to the optimum job for the current weather and time\n\nRequires Gearsets to take the form of "Cosmic BSM"
plugin_dependencies: ICE
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

        function b.AtkNumber(c)
            local d = string.gsub(c, ',', '')
            local e = tonumber(d)

            return e
        end
        function b.quote(c)
            return '"' .. tostring(c) .. '"'
        end
        function b.TableContains(c, d)
            for e = 1, #c do
                if c[e] == d then
                    return true
                end
            end

            return false
        end

        return b
    end
    function a.b()
        local b = math.floor
        local c = {}
        local d = 60
        local e = 36E2

        function c.ET()
            local f = Instances.Framework.EorzeaTime
            local g = f % 86400
            local h = b(g / e)
            local i = b((g % 3600) / d)

            return {
                bell = h,
                minute = i,
            }
        end

        return c
    end
end

local b = a.load'a'
local c = a.load'b'
local d = false
local e = 49
local f = 148
local g = {
    {
        job = 'CRP',
        atk = 3,
        score = 0,
        weather = {e},
        hours = {0, 1},
    },
    {
        job = 'BSM',
        atk = 7,
        score = 0,
        weather = {f},
        hours = {4, 5},
    },
    {
        job = 'ARM',
        atk = 11,
        score = 0,
        weather = {f},
        hours = {8, 9},
    },
    {
        job = 'GSM',
        atk = 15,
        score = 0,
        weather = {f},
        hours = {12, 13},
    },
    {
        job = 'LTW',
        atk = 19,
        score = 0,
        weather = {e},
        hours = {16, 17},
    },
    {
        job = 'WVR',
        atk = 23,
        score = 0,
        weather = {e},
        hours = {20, 21},
    },
    {
        job = 'ALC',
        atk = 27,
        score = 0,
        weather = {f},
        hours = {0, 1},
    },
    {
        job = 'CUL',
        atk = 31,
        score = 0,
        weather = {f},
        hours = {4, 5},
    },
}
local h = 500000

local function CESwitchJob()
    local i = 'NONE'
    local j = h
    local k = Instances.EnvManager.ActiveWeather
    local l = c.ET().bell
    local m = Addons.GetAddon'WKSScoreList'

    if not m.Exists then
        yield'/e Score list is not visible'

        return
    end

    for n, o in ipairs(g)do
        local p = m:GetAtkValue(o.atk).ValueString
        local q = b.AtkNumber(p)

        if q == nil then
            q = 0
        end
        if q < h then
            if b.TableContains(o.weather, k) then
                q = q - h * 2
            elseif b.TableContains(o.hours, l) and d then
                q = q - h
            end
        end
        if q < j then
            j = q
            i = o.job
        end

        g[n].score = q
    end

    if i ~= 'NONE' then
        local n = 'Cosmic ' .. i

        yield('/gs change ' .. b.quote(n))
        yield'/icecosmic start'
    end
end

CESwitchJob()
