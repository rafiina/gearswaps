sets.tp.dt = {
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
    ammo = 'Coiste Bodhar',
    head = 'Flam. Zucchetto +2',
    hands = 'Sulev. Gauntlets +2',
    legs = 'Sulev. Cuisses +2',
    feet = 'Flam. Gambieras +2',
    neck = 'Warrior\'s Beads',
    waist = 'Windbuffet Belt +1',
    right_ear = 'Mache Earring',
    left_ear = 'Brutal Earring',
    left_ring = { name = 'Chirich Ring', bag = 'wardrobe3' },
    right_ring = { name = 'Chirich Ring', bag = 'wardrobe2' },
}
