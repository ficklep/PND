--[[SND Metadata]]
author: PM
version: 0.1.0
description: Automatically uses Elixir periodically while searching for treasure
--[[End Metadata]]

local function hasStatus(a)
    local b = Player.Status

    for c in luanet.each(b)do
        if c.StatusId == a then
            return true
        end
    end

    return false
end
local function PotElixir()
    while hasStatus(1531) do
        yield'/keyitem "Magical Elixir"'
        yield'/wait 6'
    end
end

PotElixir()
