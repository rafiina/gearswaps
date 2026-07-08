-- idle sets

sets.idle          = {}

-- Overcaps DT
sets.idle.turtle   = {
    main = "Sakpata's Sword",
    sub = 'Bolelabunga',
    head = 'Malignance Chapeau',
    neck = 'Twilight Torque',
    left_ear = 'Alabaster Earring',
    -- replace grit with: https://www.bg-wiki.com/ffxi/Etiolation_Earring
    right_ear = 'Grit Earring',
    body = 'Malignance Tabard',
    hands = 'Malignance Gloves',
    left_ring = 'Defending Ring',
    right_ring = 'Murky Ring',
    back = SucellosCape.tp,
    -- add https://www.bg-wiki.com/ffxi/Plat._Mog._Belt
    legs = 'Carmine Cuisses +1',
    feet = 'Malignance Boots'
}

-- capped DT
sets.idle.refresh  = set_combine(
    sets.idle.turtle,
    {
        main = 'Daybreak',
        sub = 'Bolelabunga',
        ammo = 'Homiliary',
        head = 'Viti. Chapeau +4',
        body = 'Lethargy Sayon +3'
    }
)

-- capped DT
sets.idle.refresh.sw  = set_combine(
    sets.idle.turtle,
    {
        main = 'Daybreak',
        sub = 'Archduke\'s Shield',
        ammo = 'Homiliary',
        head = 'Viti. Chapeau +4',
        body = 'Lethargy Sayon +3'
    }
)

sets.idle.mevasion = set_combine(
    sets.idle.turtle,
    {

    }
)
