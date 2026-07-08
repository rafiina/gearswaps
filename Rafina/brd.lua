include('Modes.lua')
local common = include('lib/common')
local helpers = include('lib/helper_functions')

common.weaponskill = 'Evisceration'

local AutoWSModeValues = { 'on', 'off' }
local AutoWSMode = M(AutoWSModeValues)
AutoWSMode:describe('TpMode Valid Options: ' .. table.concat(AutoWSModeValues, ', '))
AutoWSMode:set('off')
common.modes = {
    AutoWSMode = AutoWSMode
}
common.init_modes_display()

sets.idle = {}


function get_sets()
    -- Sets use format: sets.[mode].[spellname]
    -- Example: For a JA named Provoke: sets.ja.Provoke or sets.ja['Provoke']

end

-- User Event Functions

function precast(spell)
end

function midcast(spell)
end

function aftercast(spell)
end

function buff_change(name, gain)
end

function self_command(command)
end

-- User Defined Functions

function self_command(command)
    local commandArgs = command

    common.handle_command(commandArgs)
end
