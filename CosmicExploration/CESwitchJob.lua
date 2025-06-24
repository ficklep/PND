--[[SND Metadata]]
author: PM
version: 0.1.0
description: Switches to the optimum job for the current weather and time
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

        return b
    end
end

local b = a.load'a'
local c = {
    {
        job = 'CRP',
        atk = 3,
        score = 0,
    },
    {
        job = 'BSM',
        atk = 7,
        score = 0,
    },
    {
        job = 'ARM',
        atk = 11,
        score = 0,
    },
    {
        job = 'GSM',
        atk = 15,
        score = 0,
    },
    {
        job = 'LTW',
        atk = 19,
        score = 0,
    },
    {
        job = 'WVR',
        atk = 23,
        score = 0,
    },
    {
        job = 'ALC',
        atk = 27,
        score = 0,
    },
    {
        job = 'CUL',
        atk = 31,
        score = 0,
    },
}

local function CESwitchJob()
    local d = 'NONE'
    local e = 500000
    local f = Addons.GetAddon'WKSScoreList'

    if not f.Exists then
        yield'/e Score list is not visible'
    end

    for g, h in ipairs(c)do
        local i = f.GetAtkValue(h.atk).ValueString
        local j = b.AtkNumber(i)

        if j == nil then
            j = 0
        end
        if j > e then
            e = j
            d = h.job
        end

        c[g].score = j
    end

    local g = 'Cosmic ' .. d

    yield('/gs change ' .. b.quote(g))
end

CESwitchJob()
