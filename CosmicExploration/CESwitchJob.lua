--[=====[
[[SND Metadata]]
author: PM
version: 0.4.0
description: Switches to the optimum job for the current weather and time\n\nRequires Gearsets to take the form of "Cosmic BSM"
plugin_dependencies: ICE
configs:
  targetScore:
    default: 500000
    description: Target score to stop switching to a job at
    type: int
    min: 1
    required: true
  enableTimed:
    default: false
    description: Enable timed based job switching
    type: bool
    required: true
  enableWeather:
    default: true
    description: Enable weather based job switching
    type: bool
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
        local c = 60
        local d = 36E2

        function ETime()
            local e = Instances.Framework.EorzeaTime
            local f = e % 86400
            local g = b(f / d)
            local h = b((f % 3600) / c)

            return {
                bell = g,
                minute = h,
            }
        end

        return ETime
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

local b = a.load'a'
local c = a.load'b'
local d = a.load'd'
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

local function CESwitchJob()
    local h = tonumber(Config.Get'targetScore')
    local i = Config.Get'enableTimed'
    local j = Config.Get'enableWeather'

    Dalamud.LogVerbose('Target score: ' .. h)
    Dalamud.LogVerbose('Timed enabled: ' .. tostring(i))
    Dalamud.LogVerbose('Weather enabled: ' .. tostring(j))

    local k = 'NONE'
    local l = h
    local m = Instances.EnvManager.ActiveWeather
    local n = c().bell
    local o = Addons.GetAddon'WKSScoreList'

    if not o.Exists then
        d('Score list is not visible.', true)

        return
    end

    for p, q in ipairs(g)do
        local r = o:GetAtkValue(q.atk).ValueString
        local s = b.AtkNumber(r)

        if s == nil then
            s = 0
        end
        if s < h then
            if b.TableContains(q.weather, m) and j then
                s = s - h * 2
            elseif b.TableContains(q.hours, n) and i then
                s = s - h
            end
        end
        if s < l then
            l = s
            k = q.job
        end

        g[p].score = s
    end

    if k ~= 'NONE' then
        local p = 'Cosmic ' .. k

        yield('/gs change ' .. b.quote(p))
        yield'/icecosmic start'
    end
end

CESwitchJob()
