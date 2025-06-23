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
        atk = 10,
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
        job = 'ALC',
        atk = 26,
        score = 0,
    },
    {
        job = 'CUL',
        atk = 31,
        score = 0,
    },
}

local function CESwitchJob()
    local d = Addons.GetAddon'WKSScoreList'

    if not d.Exists then
        yield'/e Score list is not visible'
    end

    for e, f in ipairs(c)do
        local g = d:GetAtkValue(f.atk).ValueString

        c[e].score = b.AtkNumber(g)

        yield('/e ' .. tostring(c[e].score))
    end
end

CESwitchJob()
