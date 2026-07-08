require('Modes')

require('rdm/spell_maps')

-- initialize and import sets
sets = {}
include('cor/augmented_gear')
include('cor/gearsets/weaponskill')
include('cor/gearsets/weapons')
include('cor/gearsets/tp')
include('cor/gearsets/idle')
include('cor/gearsets/precast')
include('cor/gearsets/midcast')
local common = include('lib/common')
local helpers = include('lib/helper_functions')
include('util/gearsets/common')
-- Enable style lock

send_command('wait 6; input /lockstyle on; wait 9; input /lockstyleset 4 echo')

-- Modes

local TpModeValues = { 'standard' }
local TpMode = M(TpModeValues)
TpMode:describe('TpMode Valid Options: ' .. table.concat(TpModeValues, ', '))
TpMode:set('standard')

local IdleModeValues = { 'standard' }
local IdleMode = M(IdleModeValues)
IdleMode:describe('IdleMode Valid Options: ' .. table.concat(IdleModeValues, ', '))
IdleMode:set('standard')

local WeaponModeValues = { 'savage', 'manual' }
local WeaponMode = M(WeaponModeValues)
WeaponMode:describe('WeaponMode Valid Options: ' .. table.concat(WeaponModeValues, ', '))
WeaponMode:set('manual')

common.weaponskill = 'Savage Blade'

local AutoWSModeValues = { 'on', 'off' }
local AutoWSMode = M(AutoWSModeValues)
AutoWSMode:describe('AutoWSMode Valid Options: ' .. table.concat(AutoWSModeValues, ', '))
AutoWSMode:set('off')

common.modes = {
    TpMode = TpMode,
    IdleMode = IdleMode,
    CastMode = CastMode,
    WeaponMode = WeaponMode,
    AutoWSMode = AutoWSMode
}
common.display_x = 950
common.display_y = 650
common.ws_tp_threshold = 2000
common.init_modes_display()

function get_sets()
    -- import sets
    -- sets with 'default' are fallback sets in case there is no matching set for an action
    -- or serve as base sets elsewhere
    sets.idle.current = sets.idle.standard


    sets.precast.current = sets.idle.standard

    sets.midcast.default = sets.idle.standard

    sets.tp.current = sets.tp.standard

    sets.current = {}
end

-- User Event Functions

function precast(spell)
    local set = {}
    
    set = handle_magic('precast', spell)

    if set == nil then
        set = handle_ws(spell)
    end

    if set == nil then
        set = handle_ja('precast', spell)
    end

    update_equip(set)
end

function midcast(spell)
    local set = handle_magic('midcast', spell)

    if set == nil then
        set = handle_ws(spell)
    end

    if set == nil then
        set = handle_ja('midcast', spell)
    end

    update_equip(set)
end

function aftercast(spell)
    status_change(player.status)
end

function status_change(new, old)
    -- Sometimes "Engaged" is reported as the subscript representing
    -- it in the resource files instead of the string. Check both.
    if new == 'Engaged' or new == 1 then
        enable('main', 'sub', 'range')
        set = set_combine(
            sets.tp[TpMode.current],
            sets.weapons[WeaponMode.current]
        )
        if WeaponMode.current == 'manual' then
            set = set_combine(
                sets.tp[TpMode.current],
                {
                    main = player.equipment.main,
                    sub = player.equipment.sub
                }
            )
        end
        update_equip(set)
        disable('main', 'sub', 'range')
        -- Same for Idle status
    elseif player.status == 'Idle' or new == 0 then
        update_equip(sets.idle[IdleMode.current])
    end
end

function process_mode_update(mode)
    if mode == 'TpMode' then
        sets.tp.current = sets.tp[TpMode.current]
    end

    status_change(player.status)
end

function buff_change(name, gain)
end

function self_command(command)
    local commandArgs = command

    common.handle_command(commandArgs)
end

function sub_job_change(new, old)
    send_command('wait 2;input /lockstyleset 4')
end

-- User Defined Functions

function update_equip(equip_set)
    local next = next

    if equip_set ~= nil and next(equip_set) ~= nil then
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
        handle_precast_magic(spell)
        set = sets.precast.current
        return set
    end

    set = identify_spell_subset(spell)

    return set
end

function handle_ja(state, spell)
    if spell.action_type ~= 'Ability' then
        return
    end

    local set = {}

    if state == 'precast' then
        set = sets.precast.current
        return set
    end

    set = sets.midcast.rolls

    return set
end

function handle_precast_magic(spell)
    check_ja_stances(spell)
    if spell.skill == 'Enfeebling Magic' then
        if MaccMode.current == 'high' or MaccMode.current == 'max' then
            windower.add_to_chat('high accuracy -- unlocking weapons')
            enable('main', 'sub', 'range')
        elseif MaccMode.current == 'low' then
            windower.add_to_chat('low accuracy -- keeping weapons')
            disable('main', 'sub', 'range')
        end
    elseif spell.skill == 'Enhancing Magic' then
        local spell_category = enhance_maps[spell.name]
        if spell_category == 'gain' or spell_category == 'skill' then
            enable('main', 'sub', 'range')
        end
    end
end

function handle_ws(weaponskill)
    if weaponskill.action_type ~= "WeaponSkill" then
        return
    end

    local set = {}
    if sets.ws[weaponskill.name] then
        set = sets.ws[weaponskill.name]
    else
        windower.add_to_chat('Missing set for ' .. weaponskill.name)
    end

    return set
end

function identify_spell_subset(spell)
    -- If we haven't made midcast sets for a spell type, just return a default
    if not sets.midcast[spell.skill] then
        windower.add_to_chat('Missing sets for ' .. spell.skill)
        return sets.midcast.default
    end

    local set = sets.midcast[spell.skill]

    if enfeeb_maps[spell.name] then
        set = set[enfeeb_maps[spell.name]]
    elseif enhance_maps[spell.name] then
        set = set[enhance_maps[spell.name]]

        if set[target_type] ~= nil then
            set = set[target_type]
        end
    else
        windower.add_to_chat('No set found for spell: ' .. spell.name)
        set = sets.current
    end

    return set
end

function check_ja_stances(spell)
end