require('Modes')

require('rdm/spell_maps')

-- initialize and import sets
sets = {}
include('rdm/augmented_gear')
include('rdm/gearsets/weaponskill')
include('rdm/gearsets/midcast')
include('rdm/gearsets/tp')
include('rdm/gearsets/idle')
include('rdm/gearsets/precast')
include('rdm/gearsets/weapons')
local common = include('lib/common')
local helpers = include('lib/helper_functions')
include('util/gearsets/common')
-- Enable style lock

send_command('wait 6; input /lockstyle on; wait 9; input /lockstyleset 4 echo')

-- Modes

local TpModeValues = { 'dt', 'hybrid', 'highacc', 'standard', 'enspell', 'bow', 'meva' }
local TpMode = M(TpModeValues)
TpMode:describe('TpMode Valid Options: ' .. table.concat(TpModeValues, ', '))
TpMode:set('standard')

local IdleModeValues = { 'turtle', 'mevasion', 'refresh' }
local IdleMode = M(IdleModeValues)
IdleMode:describe('IdleMode Valid Options: ' .. table.concat(IdleModeValues, ', '))
IdleMode:set('refresh')

local CastModeValues = { 'normal', 'interruptdown' }
local CastMode = M(CastModeValues)
CastMode:describe('CastMode Valid Options: ' .. table.concat(CastModeValues, ', '))
CastMode:set('normal')

local AutoStanceMode = M(false)
AutoStanceMode:describe('WeaponMode Valid Options: true, false')

local HealingMode = M(false)
HealingMode:describe('HealingMode Valid Options: true, false')

local WeaponModeValues = { 'savage', 'enspell', 'magicws', 'halo', 'manual', 'zerodmg' }
local WeaponMode = M(WeaponModeValues)
WeaponMode:describe('WeaponMode Valid Options: ' .. table.concat(WeaponModeValues, ', '))
WeaponMode:set('manual')

common.weaponskill = 'Savage Blade'

local AutoWSModeValues = { 'on', 'off' }
local AutoWSMode = M(AutoWSModeValues)
AutoWSMode:describe('AutoWSMode Valid Options: ' .. table.concat(AutoWSModeValues, ', '))
AutoWSMode:set('off')

-- low will not swap weapons, keeping TP gain
-- high will swap weapons during enfeeb to add extra macc
-- max will overwrite potency mapping, maximizing macc for all enfeebs
local MaccModeValues = { 'low', 'high', 'max' }
local MaccMode = M(MaccModeValues)
MaccMode:describe('MaccMode Valid Options: ' .. table.concat(MaccModeValues, ', '))
MaccMode:set('low')

common.modes = {
    TpMode = TpMode,
    IdleMode = IdleMode,
    CastMode = CastMode,
    AutoStanceMode = AutoStanceMode,
    WeaponMode = WeaponMode,
    MaccMode = MaccMode,
    AutoWSMode = AutoWSMode,
    HealingMode = HealingMode
}
common.display_x = 950
common.display_y = 650
common.ws_tp_threshold = 2500
common.init_modes_display()

-- TODO: Find a way to automatically swap in treasure hunter gear to tag TH
-- Ideas: Accept a command (e.g. /console gs c treasure_hunter) to initiate
-- Use a fast casting spell, non-damaing, non-DoT spell to tag
-- Frazzle II is a good choice. It also sets up Frazzle III if needed.

function get_sets()
    -- import sets
    -- sets with 'default' are fallback sets in case there is no matching set for an action
    -- or serve as base sets elsewhere
    sets.idle.current = sets.idle[IdleMode.current]


    sets.precast.current = sets.precast.default

    -- Setup midcast sets
    -- TODO: Does midcast default need to be set before loading midcast sets?
    sets.midcast.default = sets.idle.current
    sets.midcast.enfeebling.current = sets.midcast.enfeebling.duration
    sets.midcast.enhancing.current = sets.midcast.enhancing.duration
    sets.midcast.healing.current = sets.midcast.healing.cure.SELF
    sets.midcast.elemental.current = sets.midcast.elemental.potency

    sets.tp.current = sets.tp[TpMode.current]


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

    update_equip(set)
end

function aftercast(spell)
    status_change(player.status)
end

function status_change(new, old)
    -- Sometimes "Engaged" is reported as the subscript representing
    -- it in the resource files instead of the string. Check both.
    set = {}
    if new == 'Engaged' or new == 1 then
        set = sets.tp.current
        enable('main', 'sub', 'range')
        set = set_combine(
            set,
            sets.tp[TpMode.current],
            sets.weapons[WeaponMode.current]
        )
        if buffactive['Enstone'] == 1 and TpMode.current == 'enspell' then
            set = set_combine(
                set,
                sets.tp.enstone
            )
        end
        if WeaponMode.current == 'manual' then
            set = set_combine(
                set,
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
        set = sets.idle.current
        if player.sub_job:lower() ~= 'nin' and player.sub_job:lower() ~= 'dnc' and set['sw'] ~= nil then
            update_equip(set['sw'])
        else
            update_equip(set)
        end
    end
end

function process_mode_update(mode)
    if mode == 'TpMode' then
        sets.tp.current = sets.tp[TpMode.current]
    end

    if mode == 'IdleMode' then
        sets.idle.current = sets.idle[IdleMode.current]
    end

    status_change(player.status)
end

function buff_change(name, gain)
    if name == 'silence' and gain == 'True' then
        windower.add_to_chat(' !!! Silenced! !!!')
        send_command('input /item "Echo Drops" <me>')
    end
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
        handle_precast_magic(spell)
        set = sets.precast.current
        return set
    end

    set = identify_spell_subset(spell)

    if spell.skill == 'Elemental Magic' then
        set = set_combine(
            set,
            sets.midcast.elemental.current
        )
    end

    if CastMode.current == 'interruptdown' then
        set = set_combine(
            set,
            sets.interrupt
        )
    end

    if spell.skill == 'Enfeebling Magic' and MaccMode.current == 'max' then
        set = set_combine(
            set,
            sets.midcast.enfeebling.accuracy
        )
    end

    return set
end

function handle_precast_magic(spell)
    check_ja_stances(spell)
    windower.add_to_chat(17, HealingMode.current)
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
    elseif spell.skill == 'Healing Magic' and HealingMode.current == 'on' then
        enable('main', 'sub', 'range')
    end
end

function handle_ws(weaponskill)
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
        if buffactive['Saboteur'] then
            set = set_combine(
                set[enfeeb_maps[spell.name]],
                sets.midcast.enfeebling.saboteur
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
        windower.add_to_chat('No set found for spell: ' .. spell.name)
        set = sets.current
    end

    return set
end

function check_ja_stances(spell)
    if AutoStanceMode.current == 'off' then
        return
    end
    if composure_inactive() then
        cancel_spell()
        windower.chat.input('/ja "Composure" <me>')
        windower.chat.input:schedule(1, '/ma "' .. spell.english .. '" ' .. spell.target.raw .. '')
    elseif arts_inactive_and_required() then
        cancel_spell()
        windower.chat.input('/ja "Light Arts" <me>')
        windower.chat.input:schedule(1, '/ma "' .. spell.english .. '" ' .. spell.target.raw .. '')
    end
end

-- TODO:    Add some form of control so I can choose not to use this
--          when I want to preserve the recast
--          Don't use when casting trusts, for example
function composure_inactive()
    local composure = helpers.get_job_ability_by_name('Composure')
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
