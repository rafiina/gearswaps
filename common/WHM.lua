include('spell_maps')
local res = require('resources')

global_len_table = {}
local function len(T)
	local count = T['count'] or 0

	if global_len_table[T] then
		return global_len_table[T]
	end

	if count == 0 then
		for _ in pairs(T) do count = count + 1 end
		global_len_table[T] = count
	end

	return count
end

local function dump(o, nested_level)
	local nested_level = nested_level or 1
	local indentation = string.rep(" ", nested_level * 4)
	local previous_indentation = string.rep(" ", (nested_level - 1) * 4)
	if type(o) == 'table' then
		local s = '{ \n'
		count = 1
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end

			if count == len(o) then 
				value_delim = ''
			else
				value_delim = ','
			end

			if not v then
				return ''
			else
				s = s .. string.rep(" ", nested_level * 4) .. '['..k..'] = ' .. dump(v, nested_level + 1) .. value_delim .. '\n'
			end
			count = count + 1
		end
		return s .. '\n' .. previous_indentation .. '} '
	else
		return tostring(o)
	end
end

local function print_t(o)
	print(dump(o))
end

function log_error(msg)
	windower.add_to_chat(28, msg)
end

function get_sets()

end

function precast(spell)

end

function filtered_action(spell)
	if spell.name:startswith('Cure') then
		local job_id = player.main_job_id
		local job_lvl = player.main_job_level
		local sub_id = player.sub_job_id or 0
		local sub_lvl = player.sub_job_level or 0
		local spell_levels = spell.levels
		
		main_req = spell.levels[job_id] or 100
		sub_req = spell.levels[sub_id] or 100
		if job_lvl < main_req and sub_lvl < sub_req then
			log_error('Level is too low to cast' .. spell.name)
		elseif player.mp < spell.mp_cost then
			log_error('Not enough MP to cast' .. spell.name)
		else
			log_error("Cannot cast " .. spell.name .. " for unknown reason.")
		end
		
		cancel_spell()
		new_cure, msg = downgrade_cure(spell)
		log_error(msg)
		if new_cure ~= nil then
			send_command('@input /ma "' .. new_cure .. '" ' ..tostring(spell.target.raw))
		end
	end
end

function midcast(spell)

end

function aftercast(spell)

end

function status_change(new,old)

end

function self_command(command)

end

-- Custom functions

function downgrade_cure(spell)
	local new_cure = nil
	local downgrade_msg = ''
	local job_id = player.main_job_id
	local job_lvl = player.main_job_level
	local sub_id = player.sub_job_id or 0
	local sub_lvl = player.sub_job_level or 0
	local spell_levels = spell.levels
	
	if player.mp >= 227 then
		spell_levels = res.spells[cure_map.single['Cure VI'].id].levels
		main_req = spell_levels[job_id] or 100
		sub_req = spell_levels[sub_id] or 100
		if job_lvl >= main_req or sub_lvl >= sub_req then
			new_cure = 'Cure VI'
			downgrade_msg = 'This should never trigger if use in filter_action()'
			return new_cure, downgrade_msg
		end
	end
	if player.mp >= 135 then
		spell_levels = res.spells[cure_map.single['Cure V'].id].levels
		main_req = spell_levels[job_id] or 100
		sub_req = spell_levels[sub_id] or 100
		if job_lvl >= main_req or sub_lvl >= sub_req then
			new_cure = 'Cure V'
			downgrade_msg = 'Downgrading to ' .. new_cure
			return new_cure, downgrade_msg
		end
	end
	if player.mp >= 88 then
		spell_levels = res.spells[cure_map.single['Cure IV'].id].levels
		main_req = spell_levels[job_id] or 100
		sub_req = spell_levels[sub_id] or 100
		if job_lvl >= main_req or sub_lvl >= sub_req then
			new_cure = 'Cure IV'
			downgrade_msg = 'Downgrading to ' .. new_cure
			return new_cure, downgrade_msg
		end
	end
	if player.mp >= 46 then
		spell_levels = res.spells[cure_map.single['Cure III'].id].levels
		main_req = spell_levels[job_id] or 100
		sub_req = spell_levels[sub_id] or 100
		if job_lvl >= main_req or sub_lvl >= sub_req then
			new_cure = 'Cure III'
			downgrade_msg = 'Downgrading to ' .. new_cure
			return new_cure, downgrade_msg
		end
	end
	if player.mp >= 24 then
		spell_levels = res.spells[cure_map.single['Cure II'].id].levels
		main_req = spell_levels[job_id] or 100
		sub_req = spell_levels[sub_id] or 100
		if job_lvl >= main_req or sub_lvl >= sub_req then
			new_cure = 'Cure II'
			downgrade_msg = 'Downgrading to ' .. new_cure
			return new_cure, downgrade_msg
		end
	end
	if player.mp >= 8 then
		spell_levels = res.spells[cure_map.single['Cure'].id].levels
		main_req = spell_levels[job_id] or 100
		sub_req = spell_levels[sub_id] or 100
		if job_lvl >= main_req or sub_lvl >= sub_req then
			new_cure = 'Cure'
			downgrade_msg = 'Downgrading to ' .. new_cure
			return new_cure, downgrade_msg
		end
	end
	if player.mp < 8 then
		downgrade_msg = 'Insufficient MP ['..tostring(player.mp)..']. Cancelling.'
		new_cure = nil
		return new_cure, downgrade_msg
	end
end
