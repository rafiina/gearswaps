sets.midcast.enhancing                 = {}

-- Duration is the base for everything else so we can cast less often
-- It has a SELF version for casting on yourself
-- and a PLAYER version for casting on another player
-- The base version only has pieces shared by both versions
sets.midcast.enhancing.duration        = {}

-- We don't want to combine with sets.midcast.enhancing.duration directly
-- just in case it causes weird things to happen because SELF and PLAYER
-- are both members of the same table
sets.midcast.enhancing.duration.base   =
    set_combine(
        sets.midcast.default,
        {
            hands = 'Atrophy Gloves +3',
            feet = 'Leth. Houseaux +1',
            neck = 'Duelist\'s Torque',
            waist = 'Embla Sash',
            -- Ghostfyre duration is multiplicative instead of additive like Sucello!
            back = Ghostfyre.default
        }
    )

sets.midcast.enhancing.duration.SELF   =
    set_combine(
        sets.midcast.enhancing.duration.base,
        {
            body = 'Viti. Tabard +3',
            legs = TelchineLegs.buffduration,
        }
    )

sets.midcast.enhancing.duration.PLAYER =
    set_combine(
        sets.midcast.enhancing.duration.base,
        {
            head = 'Leth. Chappel +1',
            body = 'Leth. Sayon +1',
            hands = 'Leth. Gantherots +1',
            legs = 'Leth. Fuseau +1',
            feet = 'Leth. Houseaux +1',
        }
    )

-- This maximizes skill, mainly for enspells and Temper II
sets.midcast.enhancing.skill           =
    set_combine(
        sets.midcast.enhancing.duration.SELF,
        {
            head = 'Befouled Crown',
            main = 'Pukulatmuj +1',
            body = 'Viti. Tabard +3',
            legs = 'Atrophy Tights +2',
            neck = 'Enhancing Torque',
            waist = 'Olympus Sash',
            right_ear = 'Andoaa Earring',
            left_ring = 'Stikini Ring',
            right_ring = 'Stikini Ring',
            back = Ghostfyre.default
        }
    )

sets.midcast.enhancing.gain            =
    set_combine(
        sets.midcast.enhancing.skill,
        {
            hands = 'Viti. Gloves +2'
        }
    )

sets.midcast.enhancing.refresh         = {}

sets.midcast.enhancing.refresh.base    =
{
    body = 'Atrophy Tabard +2',
    legs = 'Leth. Fuseau +1'
}

sets.midcast.enhancing.refresh.SELF    =
    set_combine(
        sets.midcast.enhancing.duration.SELF,
        sets.midcast.enhancing.refresh.base
    )

sets.midcast.enhancing.refresh.PLAYER  =
    set_combine(
        sets.midcast.enhancing.duration.PLAYER,
        sets.midcast.enhancing.refresh.base
    )

sets.midcast.enhancing.phalanx         = {}

sets.midcast.enhancing.phalanx.SELF    =
    set_combine(
        sets.midcast.enhancing.duration.SELF,
        {
            main = "Sakpata's Sword"
        }
    )

sets.midcast.enhancing.phalanx.PLAYER  = sets.midcast.enhancing.duration.PLAYER

sets.midcast.enhancing.aquaveil        = sets.midcast.enhancing.duration.SELF

sets.midcast.enhancing.stoneskin       = sets.midcast.enhancing.duration.SELF

sets.midcast.enhancing.bar             = sets.midcast.enhancing.duration.SELF

sets.midcast.enhancing.regen           = {}

sets.midcast.enhancing.regen.base      =
{
    main = 'Bolelabunga',
    body = { name = 'Telchine Chas.', augments = { 'Enh. Mag. eff. dur. +10', } },
    legs = { name = 'Taeon Tights', augments = { '"Regen" potency+3', } }
}

sets.midcast.enhancing.regen.SELF      = {
    set_combine(
        sets.midcast.enhancing.duration.SELF,
        sets.midcast.enhancing.regen.base
    )
}

sets.midcast.enhancing.regen.PLAYER    =
    set_combine(
        sets.midcast.enhancing.duration.PLAYER,
        sets.midcast.enhancing.regen.base
    )

sets.midcast['Enhancing Magic']        = sets.midcast.enhancing
