res = require('resources')

-- Dump tables for print in console or chat
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ',\n'
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

-- Check if dualwielding
function dual_wielding()
    local item_data = get_equipped_item_data('sub')
    return item_data ~= 'empty' and item_data.skill and not S { 0, 30 }:contains(item_data.skill)
end

-- example usage: get_equipped_item_data('main')
function get_equipped_item_data(slot)
    local item = gearswap.items
        [gearswap.to_windower_bag_api(gearswap.res.bags[gearswap.items.equipment[slot].bag_id].en)]
        [gearswap.items.equipment[slot].slot]
    return player.equipment[slot] ~= empty and item and item.id and gearswap.res.items[item.id] or 'empty'
end

-- TODO:
--      - Lockstyle weapon detection
--      - Use dual_wielding() as reference and reference_material/skills.lua
--      - item.skill indirectly gives weapon type

-- For setting player's current rotation vector
-- stolen from Lazy via automal
packets = require('packets')
windower.register_event('outgoing chunk', function (id, data)
    if id == 0x015 then
        local action_message = packets.parse('outgoing', data)
        PlayerH = action_message['Rotation']
    end
end)

function HeadingTo(X, Y)
    local X = X - windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id).x
    local Y = Y - windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id).y
    local H = math.atan2(X, Y)
    return H - 1.5708
end

function TurnToTarget(target_id)
    local destX
    local destY
    if target_id then
        destX = windower.ffxi.get_mob_by_id(target_id).x
        destY = windower.ffxi.get_mob_by_id(target_id).y
    else
        destX = windower.ffxi.get_mob_by_target('t').x
        destY = windower.ffxi.get_mob_by_target('t').y
    end
    local direction = math.abs(PlayerH - math.deg(HeadingTo(destX, destY)))
    --add_text('dir: ' .. tostring(direction))
    --windower.add_to_chat(17, 'dir: ' .. tostring(direction))
    if direction > 10 then
        windower.ffxi.turn(HeadingTo(destX, destY))
    end
end

function get_job_ability_by_name(name)
    local abilities = windower.ffxi.get_abilities()
    local composure_recast = windower.ffxi.get_ability_recasts()

    abilities_by_name = {}
    for k, id in pairs(abilities.job_abilities) do
        ability_info = res.job_abilities[id]
        abilities_by_name[ability_info['en']] = ability_info
    end

    return abilities_by_name[name]
end
