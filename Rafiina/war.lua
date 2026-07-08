-- load class related luas
require('war/ja_maps')
require('war/helpers')
include('util/gearsets/common')
local common = include('lib/common')
-- Enable style lock

--send_command('wait 6; input /lockstyle; wait 9; input /lockstyleset 3 echo')

-- Modes

TpMode = { 'dt', 'hybrid', 'highacc', 'standard', 'enspell', 'bow', 'meva' }
TpMode.current = 'standard'
IdleMode = { 'layered_defense', 'regen', 'MEvasion' }
IdleMode.current = 'layered_defense'
CastMode = { 'normal', 'interruptdown' }
CastMode.current = 'normal'

-- TODO: Find a way to automatically swap in treasure hunter gear to tag TH
-- Ideas: Accept a command (e.g. /console gs c treasure_hunter) to initiate
-- Use a fast casting spell, non-damaing, non-DoT spell to tag
-- Frazzle II is a good choice. It also sets up Frazzle III if needed.

function get_sets()
    include('war/augmented_gear')

    sets.idle = {}
    sets.precast = {}
    sets.midcast = {}
    sets.tp = {}

    -- import sets
    -- sets with 'default' are fallback sets in case there is no matching set for an action
    -- or serve as base sets elsewhere
    include('war/idle')
    sets.idle.default = sets.idle.regen

    include('war/tp')
    sets.tp.default = sets.tp.standard

    include('war/weaponskill')

    sets.interrupt =
    {
        sub = 'Beatific Shield +1',
        legs = { name = 'Carmine Cuisses +1', augments = { 'Accuracy+20', 'Attack+12', '"Dual Wield"+6', } },
        waist = 'Othila Sash'
    }

    sets.treasurehunter =
    {
        ammo = 'Per. Lucky Egg',
        waist = 'Chaac Belt'
    }

    sets.current = {}
end

-- User Event Functions

function precast(spell)
    local set = handle_magic('precast', spell)
    if set == nil then
        set = handle_ws(spell)
    end

    update_equip(set)
end

function midcast(spell)
    local set = handle_magic('midcast', spell)

    if set == nil then
        set = handle_ws(spell)
    end

    if th_active then
        set = set_combine(set, sets.treasurehunter)
        th_active = false
    end

    update_equip(set)
end

function aftercast(spell)
    local set
    if player.in_combat then
        set = sets.tp[TpMode.current]
    elseif player.status == 'Idle' then
        set = sets.idle[IdleMode.current]
    end

    if set then
        update_equip(set)
    end
end

function status_change(new, old)
    if new == 'Engaged' then
        update_equip(sets.tp[TpMode.current])
    else
        update_equip(sets.idle[IdleMode.current])
    end
end

function buff_change(name, gain)
    if name == 'silence' and gain == 'True' then
        send_command('@input /item "Echo Drops" <me>')
    end
end

function self_command(command)
    local commandArgs = command

    if #commandArgs:split(' ') >= 2 then
        commandArgs = T(commandArgs:split(' '))
        -- TODO: Modes don't check whether a given value is valid
        if commandArgs[1]:lower() == 'meleemode' then
            TpMode.current = commandArgs[2]
        elseif commandArgs[1]:lower() == 'idlemode' then
            IdleMode.current = commandArgs[2]
            sets.midcast.default = sets.idle[IdleMode.current]
        elseif commandArgs[1]:lower() == 'castmode' then
            CastMode.current = commandArgs[2]
        end
    elseif command == 'lock' then
        disable('main', 'sub', 'range')
    elseif command == 'unlock' then
        enable('main', 'sub', 'range')
    elseif command == 'check_stances' then
        check_ja_stances()
    elseif command == 'tag_th' then
        th_active = true
        send_command('@input /ma "Frazzle II" <t>')
    end
end

function sub_job_change(new, old)
    send_command('wait 2;input /lockstyleset 3')
end

-- User Defined Functions

function update_equip(equip_set)
    local next = next

    if next(equip_set) ~= nil then
        sets.current = equip_set
        equip(equip_set)
    end
end

function handle_magic(state, spell)
    if spell.action_type ~= 'Magic' then
        return
    end

    local set = {}

    if state == 'precast' then
        set = sets.precast.default
        return set
    end

    set = identify_spell_subset(spell)

    if spell.skill == 'Enfeebling Magic' and buffactive['Saboteur'] then
        set = set_combine(set, sets.midcast.enfeebling.saboteur)
    end

    if CastMode.current == 'interruptdown' then
        set = set_combine(set, sets.interrupt)
    end

    return set
end

function handle_ws(weaponskill)
    local set = {}
    if sets.ws[weaponskill.name] then
        set = sets.ws[weaponskill.name]
    end

    return set
end

function identify_spell_subset(spell)
    -- If we haven't made midcast sets for a spell type, just return a default
    if not sets.midcast[spell.skill] then
        return sets.midcast.default
    end

    local set = sets.midcast[spell.skill]

    if enfeeb_maps[spell.name] then
        if buffactive['Saboteur'] then
            set = set_combine(
                set[enfeeb_maps[spell.name]],
                set.saboteur
            )
        else
            set = set[enfeeb_maps[spell.name]]
        end
    elseif enhance_maps[spell.name] then
        set = set[enhance_maps[spell.name]]

        target_type = spell.target.type
        if target_type == 'NPC' then
            target_type = 'PLAYER'
        end

        if set[target_type] ~= nil then
            set = set[target_type]
        end
    elseif spell.name:match('^Cur') then
        set = set.cure
    elseif spell.name == 'Cursna' then
        set = set.cursna
    else
        set = set.default
    end

    return set
end

-- TODO: Make generic for easier use elsewhere
function use_weaponskill ()
    player = windower.ffxi.get_player()

    mob = windower.ffxi.get_mob_by_target('t')
    if mob ~= nil and mob.is_npc then
        if player.in_combat and player.status == 1 then
            TurnToTarget()
            if player.vitals.tp >= 1000 then
                if mob.distance > 20 then
                    windower.add_to_chat(17, 'Too Far Away')
                else
                    --windower.add_to_chat(17, 'Using WS')
                    if mob.hpp < 100 then
                        windower.send_command('input /ja "Berserk" <me>')
                        windower.send_command('input /ja "Warcry" <me>')
                        windower.send_command('input /ja "Aggressor" <me>')
                        windower.send_command('input /ws "Savage Blade" <t>')
                    end
                end
            end
        else
            -- windower.add_to_chat(17, 'attacking target')
            windower.send_command('input /a on')
        end
    else
        -- windower.add_to_chat(17, 'finding target')
        windower.send_command('setkey escape down')
        windower.send_command('setkey escape up')
        windower.send_command('input /assist Kichito')
    end

    common.state_processing = false
end

function buff_change(buff, gain)
    local name = buff:lower()

    if name == 'corsair\'s roll' and not gain then
        windower.send_command('input /ja "corsair\'s roll" <me>')
    end
end