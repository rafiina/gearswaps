--- Sword Weaponskills

sets.ws = {}

-- 50% STR / 50% MND
sets.ws['Savage Blade'] =
{
    ammo = 'Coiste Bodhar',
    head = 'Sakpata\'s Helm',
    body = 'Sakpata\'s Plate',
    hands = 'Sakpata\'s Gauntlets',
    legs = 'Sakpata\'s Cuisses',
    feet = 'Sakpata\'s Leggings',
    neck = 'Anu Torque',
    waist = 'Sailfi Belt +1',
    left_ear = { name = 'Moonshade Earring', augments = { '"Mag.Atk.Bns."+4', 'TP Bonus +250', } },
    right_ear = 'Mache Earring',
    left_ring = 'Ayanmo Ring',
    right_ring = 'Rajas Ring',
}

-- 50% MND / 30% STR
sets.ws['Sanguine Blade'] = {
    ammo = 'Sroda Tathlum',
    head = 'Pixie Hairpin +1',
    body = 'Jhakri Robe +2',
    hands = 'Atrophy Gloves +3',
    legs = 'Jhakri Slops +2',
    feet = 'Jhakri Pigaches +2',
    waist = 'Othila Sash',
    left_ring = 'Persis Ring',
    right_ring = 'Shiva Ring',
    left_ear = 'Friomisi Earring',
    right_ear = 'Malignance Earring',
}

-- 40% STR / 40% MND
sets.ws['Seraph Blade'] =
    set_combine(
        sets.ws['Sanguine Blade'],
        {
            head = 'Jhakri Coronal +2',
            left_ear = 'Moonshade Earring'
        }
    )

-- 40% STR / 40% MND
sets.ws['Red Lotus Blade'] =
    set_combine(
        sets.ws['Sanguine Blade'],
        {
            left_ear = 'Moonshade Earring'
        }
    )

-- 73% MND (1 merit)
sets.ws['Requiescat'] =
    set_combine(
        sets.ws['Sanguine Blade'],
        {
            ammo = 'Regal Gem',
            left_ear = 'Moonshade Earring',
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
    body = 'Ayanmo Corazza +2',
    -- 56 DEX
    hands = 'Malignance Gloves',
    -- 5 DEX
    right_ring = 'Ayanmo Ring',
    left_ring = 'Rajas Ring',
    -- TODO: Needs DEX version of this ws cape
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
            left_ear = 'Moonshade Earring'
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
