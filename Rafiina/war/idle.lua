-- idle sets

sets.idle                 = {}

sets.idle.layered_defense = {
    head = 'Sakpata\'s Helm',
    body = 'Sakpata\'s Plate',
    hands = 'Sakpata\'s Gauntlets',
    legs = 'Sakpata\'s Cuisses',
    feet = 'Sakpata\'s Leggings',
    neck = 'Twilight Torque',
    right_ear = 'Grit Earring',
    left_ring = 'Defending Ring',
}

sets.idle.regen           = set_combine(
    sets.idle.layered_defense,
    {
        neck = 'Lissome Necklace',
    }
)

sets.idle.MEvasion        = set_combine(
    sets.idle.turtle,
    {

    }
)
