function get_sets()

    
end

function precast(spell)

end

function midcast(spell)

end

function aftercast(spell)

end

function status_change(new,old)
	if new == 'Engaged' and player.name == 'Rafina' then
		send_command('sat allattack')
	end
end

function self_command(command)

end
