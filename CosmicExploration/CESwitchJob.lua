--[[SND Metadata]]
author: PM
version: 0.1.0
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
        local b = {}
        local c = 60
        local d = 36E2

        function b.ET()
            local e = Instances.EnvManager.DayTimeSeconds
            local f = (e // c) % 60
            local g = e // d

            return {
                bell = math.floor(g),
                minute = math.floor(f),
            }
        end
        function b.Bell()
            local e = Instances.EnvManager.DayTimeSeconds

            return math.floor(e // d)
        end
        function b.Minute()
            local e = Instances.EnvManager.DayTimeSeconds

            return math.floor((e // c) % 60)
        end

        return b
    end
end

local b = a.load'a'
local c = a.load'b'
local d = 49
local e = 148
local f = {
    {
        job = 'CRP',
        atk = 3,
        score = 0,
        weather = {d},
        hours = {0, 1},
    },
    {
        job = 'BSM',
        atk = 7,
        score = 0,
        weather = {e},
        hours = {4, 5},
    },
    {
        job = 'ARM',
        atk = 11,
        score = 0,
        weather = {e},
        hours = {8, 9},
    },
    {
        job = 'GSM',
        atk = 15,
        score = 0,
        weather = {e},
        hours = {12, 13},
    },
    {
        job = 'LTW',
        atk = 19,
        score = 0,
        weather = {d},
        hours = {16, 17},
    },
    {
        job = 'WVR',
        atk = 23,
        score = 0,
        weather = {d},
        hours = {20, 21},
    },
    {
        job = 'ALC',
        atk = 27,
        score = 0,
        weather = {e},
        hours = {0, 1},
    },
    {
        job = 'CUL',
        atk = 31,
        score = 0,
        weather = {e},
        hours = {3, 5},
    },
}
local g = 500000

local function CESwitchJob()
    local h = 'NONE'
    local i = 500000
    local j = Instances.EnvManager.IsInGame
    local k = c.Bell()
    local l = Addons.GetAddon'WKSScoreList'

    if not l.Exists then
        yield'/e Score list is not visible'
    end

    for m, n in ipairs(f)do
        local o = l:GetAtkValue(n.atk).ValueString
        local p = b.AtkNumber(o)

        if p == nil then
            p = 0
        end
        if p < i and p < g then
            if b.TableContains(n.weather, j) then
                p = p - g * 2
            elseif b.TableContains(n.hours, k) then
                p = p - g
            end

            i = p
            h = n.job
        end

        f[m].score = p
    end

    if h ~= 'NONE' then
        local m = 'Cosmic ' .. h

        yield('/gs change ' .. b.quote(m))
        yield'/icecosmic start'
    end
end

CESwitchJob()
