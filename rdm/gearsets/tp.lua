-- 46% DT, capped on pdt at 56%
sets.tp.dt = {
    -- 10%
    main = 'Sakpata\'s Sword',
    sub = 'Daybreak',
    ammo = 'Coiste Bodhar',
    -- We don't set a range slot so we can use ammo for WS
    --range = 'Kaja Bow',
    -- 6%
    head = 'Malignance Chapeau',
    -- 9%
    body = 'Malignance Tabard',
    -- 5%
    hands = 'Malignance Gloves',
    -- 7%
    legs = 'Malignance Tights',
    -- 4%
    feet = 'Malignance Boots',
    neck = 'Anu Torque',
    waist = 'Sailfi Belt',
    right_ear = 'Dedition Earring',
    left_ear = 'Suppanomimi',
    -- 10%
    left_ring = 'Defending Ring',
    right_ring = 'Chirich Ring',
    -- 10% physical
    back = SucellosCape.tp
}

-- TODO: Need a proper magic evasion set with Bunzi
sets.tp.meva = sets.tp.dt

-- dual wield III = 25%
-- example: viti sword + day break
-- delay: 326.2
-- 58 tp per swing -> 18 swings
-- with stp (62): 93.9 -> 11
-- delay (with haste II and gear): 146.7
-- rate (with haste II and gear): 2.45s / attack
-- minimum for 1000tp: 13.5 seconds
-- 29% TA
-- 2% QA
-- estimated 8.2s for 1000tp on average
sets.tp.standard = {
    -- We don't set a range slot so we can use ammo for WS
    --range = 'Kaja Bow',
    -- 3 stp
    ammo = 'Coiste Bodhar',
    -- 8 stp
    head = 'Malignance Chapeau',
    body = 'Malignance Tabard',
    -- 12 stp
    hands = 'Malignance Gloves',
    -- 10 stp
    legs = 'Malignance Tights',
    -- 9 stp
    feet = 'Malignance Boots',
    -- 7 stp
    neck = 'Anu Torque',
    waist = 'Windbuffet Belt +1',
    -- 8 stp
    right_ear = 'Eabani Earring',
    -- 5 dw
    left_ear = 'Suppanomimi',
    -- 5 stp
    left_ring = { name = 'Chirich Ring', bag = 'wardrobe3' },
    -- 5 stp
    right_ring = { name = 'Chirich Ring', bag = 'wardrobe2' },
    -- 10 stp TODO: need to change to 10 dw and replace suppa
    back = SucellosCape.tp,
}

-- Stance sets are meant to be combined into a base set
-- on the fly using a variable to indicate a specific state (aka stance)

-- stance set
sets.tp.hybrid = {
    {
        left_ring = 'Defending Ring'
    }
}

-- stance set
sets.tp.highacc = {
    set_combine(
        sets.tp.standard,
        {
            waist = 'Kentarch Belt +1',
            right_ear = 'Mache Earring',
        }
    )
}

-- stance set
sets.tp.enspell = {
    hands = 'Aya. Manopolas +2'
}

-- stance set
sets.tp.bow = {
    range = 'Kaja Bow'
}
