include('Modes.lua')

require('rdm/spell_maps')

-- initialize and import sets
sets.idle = {}
sets.precast = {}
sets.midcast = {}
sets.tp = {}
include('rdm/augmented_gear')
include('rdm/gearsets/weaponskill')
include('rdm/gearsets/midcast')
include('rdm/gearsets/tp')
include('rdm/gearsets/idle')
include('rdm/gearsets/precast')
include('util/helper_functions')
include('util/common')
include('util/gearsets/common')
-- Enable style lock

send_command('wait 6; input /lockstyle on; wait 9; input /lockstyleset 4 echo')

-- Modes

-- TODO:    Display table on screen showing available Mode for current set
--          and currently selected mode.
TpMode = M { 'dt', 'hybrid', 'highacc', 'standard', 'enspell', 'bow', 'meva' }
TpMode:set('standard')
IdleMode = M { 'turtle', 'evasion', 'refresh' }
IdleMode:set('turtle')
CastMode = M { 'normal', 'interruptdown' }
CastMode:set('normal')

-- TODO: Find a way to automatically swap in treasure hunter gear to tag TH
-- Ideas: Accept a command (e.g. /console gs c treasure_hunter) to initiate
-- Use a fast casting spell, non-damaing, non-DoT spell to tag
-- Frazzle II is a good choice. It also sets up Frazzle III if needed.

function get_sets()
    -- import sets
    -- sets with 'default' are fallback sets in case there is no matching set for an action
    -- or serve as base sets elsewhere
    sets.idle.default = sets.idle.turtle


    -- Setup midcast sets
    -- TODO: Does midcast default need to be set before loading midcast sets?
    sets.midcast.default = sets.idle.default
    sets.midcast.enfeebling.default = sets.midcast.enfeebling.duration
    sets.midcast.enhancing.default = sets.midcast.enhancing.duration
    sets.midcast.healing.default = sets.midcast.healing.cure.SELF
    sets.midcast.elemental.default = sets.midcast.elemental.potency

    sets.tp.default = sets.tp.standard


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
    print(spell.name)
    local set = handle_magic('precast', spell)
    if set == nil then
        set = handle_ws(spell)
    end

    update_equip(set)
end

function midcast(spell)
    print(spell.name)
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
    status_change(player.status)
end

function status_change(new, old)
    if new == 'Engaged' then
        update_equip(sets.tp[TpMode.current])
    elseif player.status == 'Idle' then
        update_equip(sets.idle[IdleMode.current])
    end
end

function buff_change(name, gain)
    if name == 'silence' and gain == 'True' then
        send_command('input /item "Echo Drops" <me>')
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
        disable('main', 'sub', 'range', 'ammo')
    elseif command == 'unlock' then
        enable('main', 'sub', 'range', 'ammo')
    elseif command == 'check_stances' then
        check_ja_stances()
    elseif command == 'tag_th' then
        th_active = true
        send_command('input /ma "Frazzle II" <t>')
        -- TODO: Finish setting up mode cycling
    elseif command == 'test' then
        require('texts')
        require('chat')

        local my_colored_text = ('color1'):text_color(0, 255, 0)
        local my_colored_text2 = (' color2'):text_color(255, 0, 0)
        my_text_box = texts.new(my_colored_text .. my_colored_text2)
        my_text_box:visible(true)
        my_text_box:pos_x(100)
        my_text_box:pos_y(500)
    elseif command == 'test2' then
        my_text_box:color(0, 255, 0)
    end
end

function sub_job_change(new, old)
    send_command('wait 2;input /lockstyleset 4')
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
    print(spell.name)
    if spell.action_type ~= 'Magic' then
        return
    end

    local set = {}

    if state == 'precast' then
        check_ja_stances()
        set = sets.precast.default
        return set
    end

    set = identify_spell_subset(spell)

    if spell.skill == 'Enfeebling Magic' and buffactive['Saboteur'] then
        set = set_combine(set, sets.midcast.enfeebling.saboteur)
    end

    if spell.skill == 'Elemental Magic' then
        set = set_combine(set, sets.midcast.elemental.default)
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

    print(spell.skill)

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

function check_ja_stances()
    if composure_inactive() and arts_inactive_and_required() then
        cast_delay(2)
        send_command('input /ja "Composure" <me>;wait 1.2;input /ja "Light Arts" <me>')
    elseif composure_inactive() then
        cast_delay(2)
        send_command('input /ja "Composure" <me>')
    elseif arts_inactive_and_required() then
        cast_delay(2)
        send_command('input /ja "Light Arts" <me>')
    end
end

-- TODO:    Add some form of control so I can choose not to use this
--          when I want to preserve the recast
--          Don't use when casting trusts, for example
function composure_inactive()
    local composure = get_job_ability_by_name('Composure')
    local composure_recast = windower.ffxi.get_ability_recasts()[composure['recast_id']]
    --print(composure_recast)

    if not buffactive['Composure'] and composure_recast == 0 then
        return true
    end

    return false
end

-- TODO: Remove magic number 228 using get_job_ability_by_name()
function arts_inactive_and_required()
    local light_arts_recast = windower.ffxi.get_ability_recasts()[228]

    if player.sub_job == 'SCH' and not (buffactive['Light Arts'] or buffactive['Dark Arts']) and light_arts_recast == 0 then
        return true
    end

    return false
end
