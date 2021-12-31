-- Enable style lock

send_command('wait 6;input /lockstyle 3')

function sub_job_change(new,old)
	send_command('wait 2;input /lockstyle 3')
end

function tableContains(table, item)
    for key, value in pairs(table) do
        if value == item then return true end
    end
    return false
end

function get_sets()

	-- Sets use format: sets.[mode].[spellname]
	-- Example: For a JA named Provoke: sets.ja.Provoke or sets.ja['Provoke']

	AlaunusCape = {}
		AlaunusCape.fastcast = {name = "Alaunus's Cape", augments = {'"Fast Cast"+10%'}}
		
	VanyaHood = {}
		VanyaHood.fastcast = { name = "Vanya Hood", augments = {'MP+50','"Fast Cast"+10','Haste+2%',}}
		
	VanyaClogs = {}
		VanyaClogs.curecast = { name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}}
		
	TelchineBody = {}
		TelchineBody.buffduration = { name = "Telchine Chas.", augments = {'Enh. Mag. eff. dur. +10',}}

	sets.idle = {}
	sets.melee = {}
	sets.ws = {}
	sets.ja = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}
	sets.enhancing = {}

	sets.idle.normal  =  	{
								main = "Malignance Pole", -- 20% DT
								ammo = "Homiliary", -- Refresh +1
								head = "Ayanmo Zucchetto +2", -- 3% DT
								neck = "Bathy Choker +1", -- 3 regen
								body = "Ayanmo Corazza +2", -- 6% DT
								hands = "Ayanmo Manopolas +2", -- 3% DT
								left_ring = "Defending Ring", -- 10% DT
								right_ring = "Ayanmo Ring", -- 3% DT
								legs = "Ayanmo Cosciales +1", -- 4% DT
								feet = "Ayanmo Gambieras +1" -- 2% DT
							}

	sets.precast.default =  {
								ammo = "Incantor Stone", 
								head = VanyaHood.fastcast,
								ear1 = "Malignance Earring",
								left_ring = "Weatherspoon ring",
								back = AlaunusCape.fastcast,
							}

	-- 33% cure cast, 31% fast cast
	sets.precast.Cure  =	set_combine(
							sets.precast.default,
								{
									sub = "Sors Shield",
									legs = "Ebers Pantaloons +1",
									feet = "Vanya Clogs"
								}
							)
	
	sets.midcast.default = sets.idle.normal
	
	sets.midcast.Cursna =	set_combine(
								sets.midcast.default,
								{
									head = VanyaHood.fastcast,
									hands = { name="Fanatic Gloves", augments={'MP+5','Healing magic skill +2','"Fast Cast"+1',}},
									feet = VanyaClogs.curecast,
									neck = "Malison Medallion",
									left_ring = "Ephedra Ring",
									right_ring = "Ephedra Ring",
									back = AlaunusCape.fastcast,
								}
							)
							
	sets.midcast.Na =	set_combine(
								sets.midcast.default
							)
	
	sets.enhancing.base =	set_combine(
								sets.midcast.default,
								{
									body = TelchineBody.buffduration,
									legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +9',}},
									feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +10',}},
									neck="Enhancing Torque",
									waist="Cascade Belt",
									left_ear="Andoaa Earring",
									left_ring="Stikini Ring",
									right_ring="Stikini Ring",
								}
							)
	
	sets.midcast.Bar = 		set_combine( 
								sets.enhancing.base, 
								{
									legs = "Ebers Pant. +1",
									feet = "Ebers Duckbills +1",
									back = AlaunusCape.fastcast,
								}
							)
							
	sets.midcast.Regen = 	set_combine( 
								sets.enhancing.base, 
								{
									main = "Bolelabunga"
								}
							)

	sets.midcast.Cure  =  	
							{
								main = "Daybreak", -- 30%
								sub = "Sors Shield", -- 3%
								ammo = "Incantor Stone", -- 2% FC
								head = "Vanya Hood", -- 10%
								ear1 = "Malignance Earring", -- 5% FC
								ear2 = "Beatific Earring", -- 4 skill
								body = "Ayanmo Corazza +2", -- 6% DT, 4% haste
								hands = "Ayanmo Manopolas +2", -- 3% DT, 4% haste
								left_ring = "Weatherspoon ring", -- 5% FC
								right_ring = "Sirona's Ring", -- 3 MND, 3 VIT, 10 skill
								back = "Oretania's Cape +1", -- 6%
								waist = "Othila Sash", -- 10% spell interruption
								legs = "Ebers Pantaloons +1", -- 6% MP return
								feet = "Vanya Clogs" -- 5%, 20 skill
							}

	

end

-- User Event Functions

function precast(spell)
--send_command('@input /echo -- precast --')

	handle_magic('precast', spell)

end

function midcast(spell)

	equip(sets.midcast.default)
	handle_magic('midcast', spell)
	
end

function aftercast(spell)

	idle()
	
end

function buff_change(name,gain)

	if name == 'silence' and gain =='True' then
		send_command('@input /item "Echo Drops" <me>')
	end

end

function self_command(command)

	if command == 'check_stances' then
		check_stances('precast')
	end

end

-- User Defined Functions

function idle()

    equip(sets.idle.normal) 
	
end

function handle_magic(mode, spell)

	if spell.action_type ~= 'Magic' then
		return
	end
	
	if mode == 'precast' then
		check_stances()
	end

	equip(sets[mode].default)
	
	spellname = identify_spell(spell)

	if sets[mode][spellname] then
		equip(sets[mode][spellname])
	end

end

function identify_spell(spell)

	if spell.name:match('^Cur') then
		return 'Cure'
	end
	
	if spell.name:match('^Bar') then
		return 'Bar'
	end
	
	if spell.name:match('^Regen') then
		return 'Regen'
	end
	
	if spell.name:match('.*na$') and not spell.name == 'Cursna' then
		return 'Na'
	end
	
	return spell

end

function check_stances()

	if afflatus_inactive() and arts_inactive_and_required() then
		cast_delay(2)
		send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
	elseif afflatus_inactive() then
		cast_delay(2)
		send_command('@input /ja "Afflatus Solace" <me>')
	elseif arts_inactive_and_required() then
		cast_delay(2)
		send_command('@input /ja "Light Arts" <me>')
	end

end

function afflatus_inactive()

	if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
		return true
	end
	
	return false

end

function arts_inactive_and_required()

	send_command('@input /echo test2')
	if player.sub_job == 'SCH' and not (buffactive['Light Arts'] or buffactive['Dark Arts']) then
		return true
	end
	
	return false

end