sets.midcast.healing             = {}

sets.midcast.healing.cure        = {
    main = 'Daybreak',
    sub = "Sakpata's Sword",
    ammo = 'Regal Gem',
    head = { name = 'Vanya Hood', augments = { 'MP+50', '"Fast Cast"+10', 'Haste+2%', } },
    body = { name = 'Viti. Tabard +3', augments = { 'Enhances "Chainspell" effect', } },
    hands = 'Atrophy Gloves +4',
    legs = 'Atrophy Tights +3',
    feet = { name = 'Vanya Clogs', augments = { '"Cure" potency +5%', '"Cure" spellcasting time -15%', '"Conserve MP"+6', } },
    neck = 'Twilight Torque',
    waist = 'Cascade Belt',
    left_ear = 'Lifestorm Earring',
    left_ring = 'Stikini Ring',
    right_ring = 'Stikini Ring',
    back = SucellosCape.mndacc
}

sets.midcast.healing.cure.SELF   =
    set_combine(
        sets.midcast.healing.cure,
        {
        }
    )

sets.midcast.healing.cure.PLAYER = sets.midcast.healing.cure

sets.midcast.healing.cursna      =
{
    neck = 'Malison Medallion',
    back = 'Oretania\'s Cape +1'
}

sets.midcast['Healing Magic']    = sets.midcast.healing
