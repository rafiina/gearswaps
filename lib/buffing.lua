local helpers = require('lib/helper_functions')
local res = require('resources')

require('lor/lor_utils')
_libs.lor.req('settings', 'packets', 'actor')

local buffs = {
    buff_list = T{},
    debuff_list = T{},
}

buffs.settings = _libs.lor.settings.load('data/buffing_settings.lua')
--buffs.settings:save()

Me = {}
_G["Me"] = _libs.lor.actor.Actor.new()


function buffs.register_buff(target, buff_spell_name, buff_name, other_targets)
    buffs.buff_list[target.name] = buffs.buff_list[target.name] or T{}
    buffs.buff_list[target.name][buff_name] =
    T{
        active = false,
        spell_name = buff_spell_name,
        other_targets = other_targets or T{}
    }
    windower.add_to_chat(17, helpers.dump(buffs.buff_list))
end

function buffs.do_buffs()
    local queue = buffs.build_queue()
    local moving = Me:is_moving()
    local acting = Me:is_acting()

    for target, spells in pairs(queue) do
        windower.add_to_chat(17, "Current Queue:\n" .. helpers.dump(queue) .. "\n\n")
        for i, spell in pairs(spells) do
            if not (moving or acting) then
                windower.send_command('input /ma "' .. spell .. '" ' .. target)
                spells:delete(spell)
            end
        end
    end

    windower.add_to_chat(17, "Current Queue:\n" .. helpers.dump(queue) .. "\n\n")
end

-- TODO:    Detect when buffs wear off on allies so they can be added to queue
--          For now, we just recast buffs on allies when our own wears off
function buffs.build_queue()
    local buff_queue = T{}
    local player = windower.ffxi.get_player()
    local player_buffs = T{}
    
    for i, buff_id in pairs(player.buffs) do
        player_buffs[i] = res.buffs[buff_id].en
    end
    
    windower.add_to_chat(17, "buff list: " .. helpers.dump(player_buffs))

    if player ~= nil then
        -- loop through players in buff_list
        -- loop through buffs for each player
        -- if buff for that player is not active, add to queue
        for target, buff_list in pairs(buffs.buff_list) do
            if target == player.name then -- Until we can detect worn buffs on others
                for buff_name, attrs in pairs(buff_list) do
                    windower.add_to_chat(17, 'target: ' .. target .. '\nbuff_name: ' .. buff_name .. '\nattrs: ' .. helpers.dump(attrs))
                    windower.add_to_chat(17, 'has buff: ' .. tostring(player_buffs:contains(buff_name)))
                    if player_buffs:contains(buff_name) then
                        buffs.buff_list[target][buff_name]['active'] = true -- not currently used
                    else
                        buff_queue[player.name] = buff_queue[player.name] or T{}
                        buff_queue[player.name]:append(attrs.spell_name)
                        
                        if attrs.other_targets ~= nil then
                            for _, other_target in pairs(attrs.other_targets) do
                                buff_queue[other_target] = buff_queue[other_target] or T{}
                                buff_queue[other_target]:append(attrs.spell_name)
                            end
                        end
                    end
                end
            end
        end
        
        windower.add_to_chat(17, helpers.dump(buff_queue))
    end
    
    return buff_queue
end

function buffs.save_buffs(settings)
    settings.buff_list = buffs.buff_list
    settings:save()
end

function buffs.load_buffs(settings)
    buffs.buff_list = settings.buff_list 
end

return buffs