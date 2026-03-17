-- idle sets

sets.idle          = {}

sets.idle.turtle   = {
    main = "Sakpata's Sword",
    sub = 'Bolelabunga',
    head = 'Malignance Chapeau',
    body = 'Malignance Tabard',
    hands = 'Malignance Gloves',
    legs = 'Carmine Cuisses +1',
    feet = 'Malignance Boots',
    neck = 'Twilight Torque',
    right_ear = 'Grit Earring',
    left_ring = 'Defending Ring',
    right_ring = 'Ayanmo Ring',
}

sets.idle.refresh  = set_combine(
    sets.idle.turtle,
    {
        main = 'Daybreak',
        sub = 'Bolelabunga',
        ammo = 'Homiliary',
        head = { name = 'Viti. Chapeau +2', augments = { 'Enfeebling Magic duration', 'Magic Accuracy', } },
        body = 'Jhakri Robe +2'
    }
)

sets.idle.MEvasion = set_combine(
    sets.idle.turtle,
    {

    }
)
