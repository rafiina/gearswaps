windower.register_event('zone change', function (new, old)
    local western_adoulin = 256
    local eastern_adoulin = 257

    if new == western_adoulin or new == eastern_adoulin then
        equip(sets.idle.adoulin)
    end
end)
