include('Modes.lua')

-- Enable style lock

send_command('wait 6;input /lockstyle;wait 9;input /lockstyleset 3 echo')

-- Modes

MeleeMode = M{'dt', 'hybrid', 'highacc', 'lowacc', 'enspell'}
IdleMode = M{'turtle', 'evasion', 'refresh'}
CastMode = M{'normal', 'interruptdown'}

enfeeb_maps = {
    ['Dia']='Duration', ['Dia II']='Duration', ['Dia III']='Duration',
    ['Bio']='Duration', ['Bio II']='Duration', ['Bio III']='Duration',
    ['Paralyze']='PotencyMnd', ['Paralyze II']='PotencyMnd', 
    ['Slow']='PotencyMnd', ['Slow II']='PotencyMnd', 
    ['Addle']='PotencyMnd', ['Addle II']='PotencyMnd',
    ['Sleep']='Duration', ['Sleep II']='Duration', ['Sleepga']='Duration', 
    ['Silence']='Duration', 
    ['Inundation']='Duration', 
    ['Dispel']='Maccuracy', 
    ['Break']='Duration', 
    ['Bind']='Duration', 
    ['Blind']='PotencyInt', ['Blind II']='PotencyInt', 
    ['Gravity']='PotencyInt', ['Gravity II']='PotencyInt',
    ['Frazzle']='Maccuracy', ['Frazzle II']='Frazzle II', ['Frazzle III']='Frazzle III', 
    ['Distract']='PotencyMnd', ['Distract II']='PotencyMnd', ['Distract III']='Distract III', 
    ['Poison']='PotencyInt', ['Poison II']='PotencyInt', ['Poisonga']='PotencyInt',
	['Repose']='PotencyMnd'
}

enhance_maps = {
    ['Barfire']='Bar',['Barstone']='Bar',['Barwater']='Bar',['Baraero']='Bar',['Barblizzard']='Bar',['Barthunder']='Bar',
    ['Barfira']='Bar',['Barstonra']='Bar',['Barwatera']='Bar',['Baraera']='Bar',['Barblizzara']='Bar',['Barthundra']='Bar',
    ['Barvirus']='Bar',['Barpetrify']='Bar',['Barpoison']='Bar',['Barsilence']='Bar',['Barparalyze']='Bar',['Barblind']='Bar',['Barsleep']='Bar',
    ['Barvira']='Bar',['Barpetra']='Bar',['Barpoisonra']='Bar',['Barsilencra']='Bar',['Barparalyzra']='Bar',['Barblindra']='Bar',['Barsleepra']='Bar',
    ['Reraise']='Static',['Reraise II']='Static',['Reraise III']='Static',
    ['Protect']='Static',['Protect II']='Static',['Protect III']='Static',['Protect IV']='Static',['Protect V']='Static',
    ['Shell']='Static',['Shell II']='Static',['Shell III']='Static',['Shell IV']='Static',['Shell V']='Static',
    ['Regen']='Regen',['Regen II']='Regen',['Regen III']='Regen',['Regen IV']='Regen',['Regen V']='Regen',
    ['Refresh']='Refresh',['Refresh II']='Refresh',['Refresh III']='Refresh',
    ['Utsusemi: Ichi']='Utsusemi',['Utsusemi: Ni']='Utsusemi',
    ['Gain-STR']='Gain',['Gain-DEX']='Gain',['Gain-VIT']='Gain',['Gain-AGI']='Gain',['Gain-INT']='Gain',['Gain-MND']='Gain',['Gain-CHR']='Gain',
    ['Firestorm']='Storm',['Hailstorm']='Storm',['Windstorm']='Storm',['Sandstorm']='Storm',['Thunderstorm']='Storm',['Rainstorm']='Storm',['Aurorastorm']='Storm',['Voidstorm']='Storm',
	['Enfire']='Skill',['Enblizzard']='Skill',['Enstone']='Skill',['Enwater']='Skill',['Enaero']='Skill',['Enthunder']='Skill',
	['Enfire II']='Skill',['Enblizzard II']='Skill',['Enstone II']='Skill',['Enwater II']='Skill',['Enaero II']='Skill',['Enthunder II']='Skill',
	['Temper']='Skill',['Temper II']='Skill',
	['Phalanx']='Phalanx',['Phalanx II']='Phalanx',
	['Haste']='Static',['Haste II']='Static',
	['Stoneskin']='Stoneskin',['Aquaveil']='Aquaveil',['Blink']='Static',
	['Flurry']='Static',['Flurry II']='Static',
	['Ice Spikes']='Static',['Shock Spikes']='Static',['Blaze Spikes']='Static'
}

function get_sets()

	-- Sets use format: sets.[type].[spellname]/[mode]
	-- Example: For a JA named Provoke: sets.ja.Provoke or sets.ja['Provoke']
	-- Example: For DT melee: sets.melee.DT

	VanyaHood = {}
		VanyaHood.fastcast = { name = "Vanya Hood", augments = {'MP+50','"Fast Cast"+10','Haste+2%',}}
		
	VanyaClogs = {}
		VanyaClogs.curecast = { name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}}
		
	TelchineBody = {}
		TelchineBody.buffduration = { name = "Telchine Chas.", augments = {'Enh. Mag. eff. dur. +10',}}
	
	TelchineLegs = {}
		TelchineLegs.buffduration = { name = "Telchine Braconi", augments = {'Enh. Mag. eff. dur. +9',}}
	
	Ghostfyre = {}
		Ghostfyre.default = { name = "Ghostfyre Cape", augments = {'Enfb.mag. skill +2','Enha.mag. skill +8','Mag. Acc.+2','Enh. Mag. eff. dur. +13'}}

	SucellosCape = {}
		SucellosCape.tp = { name = "Sucellos's Cape", augments = {'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
		SucellosCape.mndacc = { name = "Sucellos's Cape", augments = {'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10',}}

	sets.idle = {}
	sets.melee = {}
	sets.ws = {}
	sets.ja = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}
	sets.enhance = {}

	sets.idle.turtle  =  	{
								main = "Sakpata's Sword",
								sub = "Bolelabunga",
								head = "Malignance Chapeau",
								body = "Ayanmo Corazza +2",
								hands = "Aya. Manopolas +2",
								legs = "Malignance Tights",
								feet = "Aya. Gambieras +1",
								neck = "Twilight Torque",
								right_ear = "Grit Earring",
								left_ring = "Defending Ring",
								right_ring = "Ayanmo Ring",
							}
							
	sets.idle.refresh  =  	set_combine(
								sets.idle.turtle,
								{
									main = "Daybreak",
									sub = "Bolelabunga",
									ammo = "Homiliary",
									head = { name="Viti. Chapeau +1", augments={'Enfeebling Magic duration','Magic Accuracy',}},
									body = "Jhakri Robe +2"
								}
							)
							
	sets.idle.MEvasion  =  	set_combine(
								sets.idle.turtle,
								{

								}
							)

	sets.precast.default =  {	-- Overcapped FC with weapon, 75% without
								main = "Sakpata's Sword",
								head = "Atro. Chapeau +1",
								body = { name = "Viti. Tabard +1", augments = {'Enhances "Chainspell" effect',}},
								legs = "Aya. Cosciales +1",
								feet = { name = "Carmine Greaves +1", augments = {'Accuracy+12','DEX+12','MND+20',}},
								left_ear = "Malignance Earring",
								left_ring = "Weather. Ring"
							}
	
	sets.midcast.default = 	sets.idle.turtle
	
	sets.midcast.Cursna =	set_combine(
								sets.midcast.default,
								{
									
								}
							)
							
	sets.midcast.Na =		set_combine(
								sets.midcast.default,
								{
								
								}
							)
	
	sets.midcast.Skill =	set_combine(
								sets.midcast.default,
								{
									main = "Pukulatmuj +1",
									body = { name = "Viti. Tabard +1", augments = {'Enhances "Chainspell" effect',}},
									hands = { name = "Viti. Gloves +1", augments = {'Enhancing Magic duration',}},
									legs = { name = "Carmine Cuisses +1", augments = {'Accuracy+20','Attack+12','"Dual Wield"+6',}},
									feet = "Leth. Houseaux +1",
									neck = "Enhancing Torque",
									waist = "Cascade Belt",
									right_ear = "Andoaa Earring",
									left_ring = "Stikini Ring",
									right_ring = "Stikini Ring",
									back = Ghostfyre.default
								}
							)
	
	sets.midcast.Static = {}
	
	sets.midcast.Static.SELF =	
							set_combine(	-- for static potency buffs
								sets.midcast.default,
								{
									head = "Leth. Chappel +1",
									body = TelchineBody.buffduration,
									hands = "Atrophy Gloves +2",
									legs = TelchineLegs.buffduration,
									feet = "Leth. Houseaux +1",
									neck = { name = "Duelist's Torque", augments = {'Path: A',}},
									back = SucellosCape.tp
								}
							)
						
	sets.midcast.Static.PLAYER =	
							set_combine(
								sets.midcast.default,
								{
									head = "Leth. Chappel +1",
									body = TelchineBody.buffduration,
									hands = "Atrophy Gloves +2",
									legs = "Leth. Fuseau +1",
									feet = "Leth. Houseaux +1",
									neck = { name = "Duelist's Torque", augments = {'Path: A',}},
									back = SucellosCape.tp
								}
							)
	
	sets.midcast.Gain = 	set_combine(
								sets.midcast.Static.SELF,
								{
								
								}
							)
	
	sets.midcast.Refresh = {}
	
	sets.midcast.Refresh.SELF =	
							set_combine(
								sets.midcast.Static.SELF,
								{
									legs = "Leth. Fuseau +1"
								}
							)
							
	sets.midcast.Refresh.PLAYER =	
							set_combine(
								sets.midcast.Static.PLAYER,
								{
									legs = "Leth. Fuseau +1"
								}
							)
							
	sets.midcast.Aquaveil =	set_combine(
								sets.midcast.Static.SELF,
								{
									
								}
							)
							
	sets.midcast.interrupt =
							set_combine(
								sets.midcast.Static.SELF,
								{
									legs = { name = "Carmine Cuisses +1", augments = {'Accuracy+20','Attack+12','"Dual Wield"+6',}},
									waist = "Othila Sash"
								}
							)
							
	sets.midcast.Stoneskin =	
							set_combine(
								sets.midcast.Static.SELF,
								{
									
								}
							)

	sets.midcast.Phalanx = {}
							
	sets.midcast.Phalanx.SELF =	
							set_combine(
								sets.midcast.Static.SELF,
								{
									main = "Sakpata's Sword"
								}
							)
							
	sets.midcast.Phalanx.PLAYER =	
							set_combine(
								sets.midcast.Static.PLAYER,
								{
									
								}
							)
	
	sets.midcast.Bar = {}
	
	sets.midcast.Bar.SELF = 
							set_combine( 
								sets.midcast.Static.SELF, 
								{
									
								}
							)
							
	sets.midcast.Bar.PLAYER = 
							set_combine( 
								sets.midcast.Static.PLAYER, 
								{
									
								}
							)
	
	sets.midcast.Regen = {}
	
	sets.midcast.Regen.SELF = 	
							set_combine( 
								sets.midcast.Static.SELF, 
								{
									main = "Bolelabunga",
									body = { name = "Telchine Chas.", augments = {'Enh. Mag. eff. dur. +10',}},
									legs = { name = "Taeon Tights", augments = {'"Regen" potency+3',}}
								}
							)
							
	sets.midcast.Regen.PLAYER = 	
							set_combine( 
								sets.midcast.Static.PLAYER, 
								{
									main = "Bolelabunga",
									body = { name = "Telchine Chas.", augments = {'Enh. Mag. eff. dur. +10',}},
									legs = { name = "Taeon Tights", augments = {'"Regen" potency+3',}}
								}
							)

	sets.midcast.Cure = {}

	sets.midcast.Cure.SELF  =  	
							{
								main = "Daybreak",
								sub = "Sakpata's Sword",
								ammo = "Kalboron Stone",
								head = { name = "Vanya Hood", augments = {'MP+50','"Fast Cast"+10','Haste+2%',}},
								body = { name = "Viti. Tabard +1", augments = {'Enhances "Chainspell" effect',}},
								hands = "Atrophy Gloves +2",
								legs = { name = "Carmine Cuisses +1", augments = {'Accuracy+20','Attack+12','"Dual Wield"+6',}},
								feet = { name = "Vanya Clogs", augments = {'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
								neck = "Twilight Torque",
								waist = "Cascade Belt",
								left_ear = "Lifestorm Earring",
								right_ear = "Beatific Earring",
								left_ring = "Stikini Ring",
								right_ring = "Kunaji Ring",
								back = { name = "Sucellos's Cape", augments = {'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10',}}
							}
							
	sets.midcast.Cure.PLAYER  =  	
							{
								main = "Daybreak",
								sub = "Sakpata's Sword",
								ammo = "Kalboron Stone",
								head = { name = "Vanya Hood", augments = {'MP+50','"Fast Cast"+10','Haste+2%',}},
								body = { name = "Viti. Tabard +1", augments = {'Enhances "Chainspell" effect',}},
								hands = "Atrophy Gloves +2",
								legs = { name = "Carmine Cuisses +1", augments = {'Accuracy+20','Attack+12','"Dual Wield"+6',}},
								feet = { name = "Vanya Clogs", augments = {'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
								neck = "Twilight Torque",
								waist = "Cascade Belt",
								left_ear = "Lifestorm Earring",
								right_ear = "Beatific Earring",
								left_ring = "Stikini Ring",
								right_ring = "Stikini Ring",
								back = { name = "Sucellos's Cape", augments = {'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10',}}
							}

	sets.midcast.Maccuracy = 	
							set_combine(
								sets.midcast.default,
								{
									main = "Sakpata's Sword",
									sub = "Daybreak",
									range = "Kaja Bow",
									head = { name = "Viti. Chapeau +1", augments = {'Enfeebling Magic duration','Magic Accuracy',}},
									body = "Atrophy Tabard +1",
									hands = "Jhakri Cuffs +2",
									legs = { name = "Chironic Hose", augments = {'Pet: Phys. dmg. taken -4%','Mag. Acc.+14','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
									feet = { name = "Vitiation Boots +1", augments = {'Immunobreak Chance',}},
									neck = { name = "Duelist's Torque", augments = {'Path: A',}},
									waist = "Ovate Rope",
									left_ear = "Lifestorm Earring",
									right_ear = "Psystorm Earring",
									left_ring = "Stikini Ring",
									right_ring = "Stikini Ring",
									back = SucellosCape.mndacc
								}
							)

	sets.midcast["Frazzle II"] = 	
							set_combine(
								sets.midcast.macc,
								{
								
								}
							)
							
	sets.midcast["Frazzle III"] = 	
							set_combine(
								sets.midcast.macc,
								{
									
								}
							)
							
	sets.midcast["Distract III"] = 	
							set_combine(
								sets.midcast.macc,
								{
									
								}
							)
							
	sets.midcast.PotencyMnd = 	
							set_combine(
								sets.midcast.macc,
								{
									
								}
							)
							
	sets.midcast.PotencyInt = 	
							set_combine(
								sets.midcast.macc,
								{
									
								}
							)
							
	sets.midcast.Duration = 	
							set_combine(
								sets.midcast.macc,
								{
									
								}
							)
							
	sets.melee.dt = 		{
								main = "Sakpata's Sword",
								sub = { name = "Beatific Shield +1", augments = {'Phys. dmg. taken -3%','Spell interruption rate down -4%','Magic dmg. taken -2%',}},
								head = "Malignance Chapeau",
								body = "Ayanmo Corazza +2",
								hands = "Aya. Manopolas +2",
								legs = "Malignance Tights",
								feet = { name = "Carmine Greaves +1", augments = {'Accuracy+12','DEX+12','MND+20',}},
								neck = "Anu Torque",
								waist = "Kentarch Belt +1",
								right_ear = "Grit Earring",
								left_ear = "Suppanomimi",
								left_ring = "Defending Ring",
								right_ring = "Chirich Ring",
								back = { name = "Sucellos's Cape", augments = {'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
							}
	
	
	sets.melee.highacc = 	{
								head = "Malignance Chapeau",
								body = "Ayanmo Corazza +2",
								hands = "Aya. Manopolas +2",
								legs = "Malignance Tights",
								feet = { name = "Carmine Greaves +1", augments = {'Accuracy+12','DEX+12','MND+20',}},
								neck = "Anu Torque",
								waist = "Kentarch Belt +1",
								right_ear = "Grit Earring",
								left_ear = "Suppanomimi",
								left_ring = "Chirich Ring",
								right_ring = "Chirich Ring",
								back = { name = "Sucellos's Cape", augments = {'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
							}
	
	sets.melee.lowacc = 	sets.melee.highacc
	
	sets.melee.hybrid = 	sets.melee.highacc
							
	sets.melee.enspell = 	sets.melee.highacc
	
	sets.ws["Savage Blade"] =
							{
								head = "Jhakri Coronal +2",
								body = "Jhakri Robe +2",
								hands = "Jhakri Cuffs +2",
								legs = "Jhakri Slops +2",
								feet = "Jhakri Pigaches +2",
								neck = "Anu Torque",
								waist = "Prosilio Belt +1",
								left_ear = { name = "Moonshade Earring", augments = {'"Mag.Atk.Bns."+4','TP Bonus +250',}},
								right_ear = "Grit Earring",
								left_ring = "Ayanmo Ring",
								right_ring = "Rajas Ring",
								back = { name = "Sucellos's Cape", augments = {'STR+20','Accuracy+20 Attack+20','STR+7','Weapon skill damage +10%',}},
							}
end

-- User Event Functions

function precast(spell)

	handle_magic('precast', spell)
	handle_ws(spell)

end

function midcast(spell)

	equip(sets.midcast.default)
	handle_magic('midcast', spell)
	handle_ws(spell)
	
end

function aftercast(spell)

	if player.status == 'Engaged' then
        equip(sets.melee[MeleeMode.current])
    elseif player.status == 'Idle' then
        equip(sets.idle[IdleMode.current])
    end
	
end

function status_change(new,old)
    
	if new == 'Engaged' then
        equip(sets.melee[MeleeMode.current])
    else
        equip(sets.idle[IdleMode.current])
    end
	
end

function buff_change(name,gain)

	if name == 'silence' and gain =='True' then
		send_command('@input /item "Echo Drops" <me>')
	end

end

function self_command(command)

	local commandArgs = command

	if #commandArgs:split(' ') >= 2 then
		commandArgs = T(commandArgs:split(' '))
		if commandArgs[1]:lower() == "meleemode" then
			MeleeMode:set(commandArgs[2])
		elseif commandArgs[1]:lower() == "idlemode" then
			IdleMode:set(commandArgs[2])
			sets.midcast.default = sets.idle[IdleMode.current]
		elseif commandArgs[1]:lower() == "castmode" then
			CastMode:set(commandArgs[2])
		end
	elseif command == "lock" then
		disable('main', 'sub', 'range')
	elseif command == "unlock" then
		enable('main', 'sub', 'range')
	elseif command == 'check_stances' then
		check_stances('precast')
	end

end

function sub_job_change(new,old)

	send_command('wait 2;input /lockstyleset 3')
	
end

-- User Defined Functions

function handle_magic(state, spell)

	if spell.action_type ~= 'Magic' then
		return
	end
	
	if state == 'precast' then
		check_stances()
		equip(sets.precast.default)
		return
	end
	
	local spellname = identify_spell(spell)
	
	if not sets[state][spellname] then
		spellname = 'default'
	end
	
	if has_target_specific_set(state, spellname) then
		equip(sets[state][spellname][spell.target.type])
	else
		equip(sets[state][spellname])
	end
	
	if CastMode.current == 'interruptdown' then
		equip(sets.midcast.interrupt)
	end

end

function has_target_specific_set(state, spell)

	if next(sets[state][spell]) then
		return true
	else
		return false
	end

end

function handle_ws(spell)

	if spell.action_type ~= 'Ability' then
		return
	end
	
	spellname = identify_spell(spell)

	if sets.ws[spellname] then
		equip(sets.ws[spellname])
	end

end

function identify_spell(spell)

	if spell.name:match('^Cur') then
		return 'Cure'
	end
	
	if spell.name:match('^Regen') then
		return 'Regen'
	end
	
	if spell.name:match('.*na$') and not spell.name == 'Cursna' then
		return 'Na'
	end
	
	if spell.skill == 'Enfeebling Magic' and enfeeb_maps[spell.name] then
		return enfeeb_maps[spell.name]
	end
	
	if spell.skill == 'Enhancing Magic' and enhance_maps[spell.name] then
		return enhance_maps[spell.name]
	end
	
	return spell.name

end

function check_stances()

	if composure_inactive() and arts_inactive_and_required() then
		cast_delay(2)
		send_command('@input /ja "Composure" <me>;wait 1.2;input /ja "Light Arts" <me>')
	elseif composure_inactive() then
		cast_delay(2)
		send_command('@input /ja "Composure" <me>')
	elseif arts_inactive_and_required() then
		cast_delay(2)
		send_command('@input /ja "Light Arts" <me>')
	end

end

function composure_inactive()

	local composure_recast = windower.ffxi.get_ability_recasts()[50]

	if not buffactive['Composure'] and composure_recast == 0 then
		return true
	end
	
	return false

end

function arts_inactive_and_required()

	local light_arts_recast = windower.ffxi.get_ability_recasts()[228]

	if player.sub_job == 'SCH' and not (buffactive['Light Arts'] or buffactive['Dark Arts']) and light_arts_recast == 0 then
		return true
	end
	
	return false

end