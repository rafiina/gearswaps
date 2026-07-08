local helpers = require('lib/helper_functions')
--local buffing = require('lib/buffing')

local this = {}
this.state_processing = false
this.modes = {}
this.weaponskill = nil
this.ws_tp_threshold = 1000
this.display_x = 100
this.display_y = 500

-- Equip Adoulin Attire in Adoulin Zones
windower.register_event('zone change', function(new, old)
    local western_adoulin = 256
    local eastern_adoulin = 257

    if new == western_adoulin or new == eastern_adoulin then
        equip(sets.idle.adoulin)
    end
end)

function do_nothing()
    return
end

function test_move()
    windower.add_to_chat(17, 'Moving: ' .. tostring(test:is_moving()))
end

-- Common support for Auto Weaponskill Usage
windower.register_event('prerender', function()
    -- state_machine()
    if not this.state_processing then
        if this.modes.AutoWSMode.current == 'on' then
            --windower.add_to_chat(17, 'Using Weaponskill')
            this.state_processing = true

            if this.weaponskill ~= nil then
                coroutine.schedule(this.use_weaponskill, 1.0)
            end
        end
    end
end)

-- initialize modes text box
require('texts')
require('chat')

function this.init_modes_display()
    this.text_box = texts.new(('%16s'):format('--- Modes ---'))
    this.text_box:font('monospace')
    for name, mode in pairs(this.modes) do
        t_name = ('%-25s : '):format(name:text_color(0, 255, 0))
        local text = t_name .. mode.current:text_color(255, 0, 0)
        this.text_box:appendline(text)
    end

    this.text_box:visible(true)
    this.text_box:pos_x(this.display_x)
    this.text_box:pos_y(this.display_y)
end

function this.update_modes_display()
    this.text_box:clear()
    for name, mode in pairs(this.modes) do
        t_name = ('%-25s : '):format(name:text_color(0, 255, 0))
        local text = t_name .. mode.current:text_color(255, 0, 0)
        this.text_box:appendline(text)
    end
end

-- overwrite
function process_mode_update(mode)
end

-- Generic Gearswap command handler for common commands
function this.handle_command(command)
    local commandArgs = command
    if #commandArgs:split(' ') >= 2 then
        commandArgs = T(commandArgs:split(' '))
        -- TODO: Modes don't check whether a given value is valid
        if commandArgs[1]:lower() == 'mode' then
            if commandArgs[2]:lower() == 'list' then
                for name, mode in pairs(this.modes) do
                    if type(mode.description) == 'string' then
                        windower.add_to_chat(17, mode.description)
                    else
                        windower.add_to_chat(28, "Invalid or missing description. Skipping.")
                    end
                end
            elseif commandArgs[2]:lower() == 'set' then
                mode = commandArgs[3]
                value = commandArgs[4]:lower()

                if value == 'toggle' then
                    this.modes[mode]:cycle()
                else
                    this.modes[mode]:set(value)
                end
                windower.add_to_chat(17, mode .. ": " .. this.modes[mode].current)
                this.update_modes_display()
                process_mode_update(mode)
            end
        elseif commandArgs[1]:lower() == 'lock' then
            equip_slot = commandArgs[2]:lower()
            windower.add_to_chat(17, 'Locking ' .. equip_slot)
            disable(equip_slot)
        elseif commandArgs[1]:lower() == 'unlock' then
            equip_slot = commandArgs[2]:lower()
            windower.add_to_chat(17, 'Unlocking ' .. equip_slot)
            enable(equip_slot)
        end
    elseif command == 'lock' then
        disable('main', 'sub')
    elseif command == 'unlock' then
        enable('main', 'sub')
    elseif command == 'test' then
        local player = windower.ffxi.get_player()
        buffing.load_buffs(buffing.settings)
        buffing.do_buffs()
    end
end

function this.use_weaponskill()
    --player = windower.ffxi.get_player()
    mob = windower.ffxi.get_mob_by_target('t')
    if mob ~= nil and mob.is_npc then
        if player.in_combat and player.status == 'Engaged' then
            --TurnToTarget()
            if player.vitals.tp >= this.ws_tp_threshold then
                if mob.distance > 20 then
                    windower.add_to_chat(17, 'Too Far Away')
                else
                    --windower.add_to_chat(17, 'Using WS')
                    if mob.hpp < 100 then
                        windower.send_command('input /ws "' .. this.weaponskill .. '" <t>')
                    end
                end
            end
        else
            -- windower.add_to_chat(17, 'attacking target')
            --windower.send_command('input /a on')
        end
    else
        -- windower.add_to_chat(17, 'finding target')
        --windower.send_command('setkey escape down')
        --windower.send_command('setkey escape up')
        --windower.send_command('input /assist Kichito')
    end

    this.state_processing = false
end

return this
