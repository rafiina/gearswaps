--- Sword Weaponskills

sets.ws = {}

-- 50% STR / 50% MND
sets.ws['Savage Blade'] =
{
    ammo = 'Coiste Bodhar',
    head = 'Viti. Chapeau +4',
    body = 'Nyame Mail',
    hands = 'Atrophy Gloves +4',
    legs = 'Nyame Flanchard',
    feet = 'Leth. Houseaux',
    neck = 'Anu Torque',
    waist = 'Sailfi Belt +1',
    left_ear = { name = 'Moonshade Earring', augments = { '"Mag.Atk.Bns."+4', 'TP Bonus +250', } },
    right_ear = 'Mache Earring',
    right_ring = 'Ayanmo Ring',
    left_ring = 'Rajas Ring',
    back = SucellosCape.ws
}

-- 50% MND / 30% STR
sets.ws['Sanguine Blade'] = {
    ammo = 'Sroda Tathlum',
    head = 'Pixie Hairpin +1',
    body = 'Lethargy Sayon +3',
    hands = 'Jhakri Cuffs +2', -- These are BiS...
    legs = 'Leth. Fuseau +2',
    feet = 'Jhakri Pigaches +2',
    waist = 'Othila Sash',
    left_ring = 'Shiva Ring',
    right_ring = 'Persis Ring',
    left_ear = 'Malignance Earring',
    right_ear = 'Friomisi Earring',
    back = SucellosCape.ws
}

-- 40% STR / 40% MND
sets.ws['Seraph Blade'] =
    set_combine(
        sets.ws['Sanguine Blade'],
        {
            head = 'Leth. Chappel +2',
            left_ear = 'Moonshade Earring'
        }
    )

-- 40% STR / 40% MND
sets.ws['Red Lotus Blade'] =
    set_combine(
        sets.ws['Seraph Blade'],
        {
        }
    )

-- 73% MND (1 merit)
sets.ws['Requiescat'] =
    set_combine(
        sets.ws['Seraph Blade'],
        {
            ammo = 'Regal Gem',
            back = SucellosCape.mndacc
        }
    )

-- 80% DEX
sets.ws['Chant du Cygne'] = {
    ammo = 'Yetshila',
    -- 40 DEX
    head = 'Malignance Chapeau',
    left_ear = { name = 'Moonshade Earring', augments = { '"Mag.Atk.Bns."+4', 'TP Bonus +250', } },
    -- 5 DEX
    right_ear = 'Mache Earring',
    -- 48 DEX
    body = 'Malignance Tabard',
    -- 56 DEX
    hands = 'Malignance Gloves',
    -- 5 DEX
    right_ring = 'Ayanmo Ring',
    left_ring = 'Rajas Ring',
    -- TODO: Needs DEX version of this ws cape
    back = SucellosCape.ws,
    waist = 'Sailfi Belt +1',
    -- 30+ att, 32 str
    legs = 'Nyame Flanchard',
    -- 40 DEX
    feet = 'Malignance Boots'
}

-- 70% DEX / 70% MND
sets.ws['Imperator'] = {}

-- 40% STR / 40% MND
sets.ws['Knights of Round'] = sets.ws['Savage Blade']

-- 50% MND / 30% STR
sets.ws['Death Blossom'] = sets.ws['Savage Blade']

--- Bow Weaponskills

-- 50% AGI / 20% STR
sets.ws['Empyreal Arrow'] = {
    head = 'Malignance Chapeau',
    legs = 'Malignance Tights',
    feet = 'Malignance Boots',
    left_ring = 'Hajduk Ring',
    right_ring = 'Paqichikaji Ring'
}

--- Dagger Weaponskills

-- 40% DEX / 40% INT
sets.ws['Aeolian Edge'] =
    set_combine(
        sets.ws['Sanguine Blade'],
        {
            head = 'Leth. Chappel +2',
            right_ear = 'Moonshade Earring'
        }
    )

-- 50% DEX
sets.ws['Evisceration'] = sets.ws['Chant du Cygne']

-- 80% STR
sets.ws['Mercy Stroke'] = {}

-- 25% DEX / 25% AGI
sets.ws['Ruthless Stroke'] = {}

--- Club Weaponskills

-- 70% MND / 30% STR
sets.ws['Black Halo'] = sets.ws['Savage Blade']
