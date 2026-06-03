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

-------------------------------------------
--|     On screen text box creation     |--
-------------------------------------------

-- Displays info about current mode states and what weaponskill is bound to F10 in text box at the bottom of the screen
local function init_display()
    -- Function Author: Rubenator
    -- Onscreen text box
    ui_x_res = windower.get_windower_settings().ui_x_res
    separator = ' | ' -- Used with onscreen boxes
    -- Settings
    gearinfotxt = {
        pos = {
            x = 1100,
            y = -30,
        },
        text = {
            font = 'Consolas',
            size = 14,
            stroke = {
                width = 1.5,
                alpha = 255,
            },
        },
        flags = {
            bottom = true,
            right = false,
            bold = true,
        },
        bg = {
            visible = false,
            alpha = 120,
        },
        padding = 1,
    }
    require('chat')
    box_data = L { -- Stays in this order
        { name = 'WSbind',  mode_name = 'ws_bind' },
        { name = 'TP', mode_name = 'tpM', colorize = function (value)
            if value == 'Fodder' then
                return 'bxwhite'
            else
                return 'bxorange'
            end
            return
        end },
        { name = 'DT',      type = 'toggle',      mode_name = 'is_dtM' },
        { name = 'WS DT',   type = 'toggle',      mode_name = 'is_wsdtM' },
        { name = 'WS Proc', type = 'toggle',      mode_name = 'is_wsprocM' },
        { name = 'Auto WS', type = 'toggle',      mode_name = 'is_autoWSM' },
    }
    -- Place job specific toggles and modes below
    box_job_data = T {
        BLM = L {
            { name = 'MACC',             type = 'toggle', mode_name = 'is_maccM' },
            { name = 'MB',               type = 'toggle', mode_name = 'is_mbM' },
            { name = 'Death Idle',       type = 'toggle', mode_name = 'is_deathidleM' },
            { name = 'Spaekona\'s Coat', type = 'toggle', mode_name = 'is_SpaekonaM' },
        },
        BLU = L {},
        BRD = L {
            { name = 'Dummy', type = 'toggle', mode_name = 'is_dummysongM' },
        },
        BST = L {},
        COR = L {
            { name = 'Luzaf', type = 'toggle', mode_name = 'is_luzafM' },
            { name = 'Flurry', mode_name = 'flurryM', colorize = function (value)
                if value == 'No Flurry' then
                    return 'bxorange'
                elseif value == 'Flurry 1' then
                    return 'bxyellow'
                elseif value == 'Flurry 2' then
                    return 'bxgreen'
                end
                return
            end },
        },
        DNC = L {
            { name = 'DW', mode_name = 'hasteM', colorize = function (value)
                if value == 'Haste Max' then
                    return 'bxgreen'
                elseif value == 'Haste 30%' then
                    return 'bxyellow'
                elseif value == 'Haste 15%' then
                    return 'bxorange'
                elseif value == 'Haste 0%' then
                    return 'bxred'
                end
                return
            end },
        },
        DRG = L {},
        DRK = L {},
        GEO = L {
            { name = 'MACC',    type = 'toggle', mode_name = 'is_maccM' },
            { name = 'MB',      type = 'toggle', mode_name = 'is_mbM' },
            { name = 'WpnSwap', type = 'toggle', mode_name = 'is_wpnSwapM' },
            { name = 'Occult',  type = 'toggle', mode_name = 'is_occultM' },
        },
        MNK = L {
            { name = 'Impfoot',   type = 'toggle', mode_name = 'is_impfootM' },
            { name = 'Verehands', type = 'toggle', mode_name = 'is_verehandsM' },
        },
        NIN = L {
            { name = 'DW', mode_name = 'hasteM', colorize = function (value)
                if value == 'Haste Max' then
                    return 'bxgreen'
                elseif value == 'Haste 30%' then
                    return 'bxyellow'
                elseif value == 'Haste 15%' then
                    return 'bxorange'
                elseif value == 'Haste 0%' then
                    return 'bxred'
                end
                return
            end },
        },
        PLD = L {},
        PUP = L {},
        RDM = L {
            { name = 'MACC', type = 'toggle', mode_name = 'is_maccM' },
            { name = 'MB',   type = 'toggle', mode_name = 'is_mbM' },
            { name = 'CastWpnSwap', mode_name = 'CastWpnSwapM', colorize = function (value)
                if value == 'Casting Swaps' then
                    return 'bxyellow'
                elseif value == 'Casting/Idle Swaps' then
                    return 'bxgreen'
                elseif value == 'No Swaps' then
                    return 'bxorange'
                end
                return
            end },
        },
        RNG = L {
            { name = 'Flurry', mode_name = 'flurryM', colorize = function (value)
                if value == 'No Flurry' then
                    return 'bxorange'
                elseif value == 'Flurry 1' then
                    return 'bxyellow'
                elseif value == 'Flurry 2' then
                    return 'bxgreen'
                end
                return
            end },
        },
        RUN = L {},
        SAM = L {},
        SCH = L {
            { name = 'MACC', type = 'toggle', mode_name = 'is_maccM' },
            { name = 'MB',   type = 'toggle', mode_name = 'is_mbM' },
        },
        SMN = L {},
        THF = L {
            { name = 'TH', mode_name = 'thM', colorize = function (value)
                if value then
                    return 'bxgreen'
                end
                return
            end },
        },
        WAR = L {},
        WHM = L {},
    }
    local box_job_data_lookup = box_job_data[player.main_job]
    if box_job_data_lookup then
        box_data = box_data:extend(box_job_data_lookup)
    end
    _box_map = T {}
    _box_mode_map = T {}
    --function string.color_by_name(str, color_name)
    --    return str:text_color(unpack(colors[color_name]))
    --end

    function update_box_value(name, value)
        local char_width = 0.7565 * gearinfotxt.text.size
        if value == nil or not name then return end
        local data = _box_map[name]
        if not data then return end
        local colorize = data.colorize
        if data.type == 'toggle' then
            colorize = colorize or function (value)
                return value and 'bxgreen' or 'bxgrey'
            end
            local color = colorize(value)
            --gearinfo[name] = (value and 'ON' or 'Off'):color_by_name(color)
            gearinfo[name] = name --:color_by_name(color)
        else
            local str = tostring(value)
            local color = colorize and colorize(str) or 'bxwhite'
            gearinfo[name] = color --str:color_by_name(color)
        end
        local char_width = 0.7565 * gearinfotxt.text.size
        local char_count = gearinfo:text():text_strip_format():length()
        local box_width = char_count * char_width + (gearinfotxt.padding or 0) * 2
        local x_pos = ui_x_res / 2 - box_width / 2
        if gearinfotxt.flags.right then -- just in case
            x_pos = pos_x - ui_x_res
        end
        gearinfo:pos_x(x_pos)
    end

    gearinfo = nil
    do
        for v in box_data:it() do
            _box_map[v.name] = v
            if v.mode_name then
                _box_mode_map[v.mode_name] = v
            end
        end
        local box_names = box_data:map(function (data) return data.name end)
        box_names = box_names:map(function (name)
            local data = _box_map[name]
            if data.type == 'toggle' then
                --return string.format('%sd ${%s}',
                --    (data.display_name or name):color_by_name(data.color or 'bxwhite'), name)
                return string.format('${%s}', name)
            else
                --return string.format('%s %s', (data.display_name or name):color_by_name(data.color or 'bxwhite'),
                --    string.format('${%s}', name):color_by_name('bxgreen'))
                return string.format('%s', string.format('${%s}', name)) --:color_by_name('bxgreen'))
            end
        end)
        gearinfo = texts.new(' ' .. box_names:concat(separator) .. ' ', gearinfotxt)
        gearinfo:show()
    end

    function init_box()
        for mode_name, mode in pairs(state) do
            local data = _box_mode_map[mode_name]
            if type(mode) == 'table' then
                if data and data.name and mode.value ~= nil then
                    update_box_value(data.name, mode.value)
                end
            elseif data and data.name then
                update_box_value(data.name, mode)
            end
        end
    end

    init_box:schedule(0.1)
end
