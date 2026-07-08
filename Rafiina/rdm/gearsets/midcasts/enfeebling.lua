sets.midcast.enfeebling          = {}

-- Maximizes accuracy.
sets.midcast.enfeebling.accuracy =
    set_combine(
        sets.midcast.enfeebling,
        {
            -- comments are contributed magic accuracy
            -- If a piece ties, max MND is chosen as tie breaker

            -- Only main hand's macc skill is used
            -- 40 + 248 macc skill = 288
            main = "Sakpata's Sword",
            -- 40
            sub = 'Daybreak',
            -- 35
            range = 'Kaja Bow',
            ammo = empty,
            -- 50
            head = 'Atrophy Chapeau +4',
            -- 45 + 19 enfeeb skill + 0 * (15 per atrophy +2/+3 or regal piece) = 64
            body = 'Atrophy Tabard +2',
            -- 24 + 19 enfeeb skill = 43
            hands = 'Leth. Ganth. +3',
            -- 54 + 13 enfeeb skill = 67
            legs = { name = 'Chironic Hose', augments = { 'Pet: Phys. dmg. taken -4%', 'Mag. Acc.+14', 'Mag. Acc.+20 "Mag.Atk.Bns."+20', } },
            -- 50
            feet = 'Vitiation Boots +3',
            -- 20
            neck = 'Null Loop',
            -- 8
            waist = 'Ovate Rope',
            -- 12 with both ears as set
            left_ear = 'Malignance Earring',
            right_ear = 'Snotra Earring',
            -- 8 + 5 enfeeb skill
            left_ring = 'Stikini Ring',
            -- 8 + 5 enfeeb skill
            right_ring = 'Stikini Ring',
            -- 20
            back = SucellosCape.mndacc
        }
    )

-- For debuffs that don't get resisted. Stacks DT.
-- This is a common base set for others
sets.midcast.enfeebling.duration =
    set_combine(
        sets.midcast.enfeebling.accuracy,
        {
            range = empty,
            ammo = 'Regal Gem',
            head = 'Leth. Chappel +2',
            -- 5 DT
            neck = 'Twilight Torque',
            -- 5 DT
            left_ear = 'Alabaster Earring',
            body = 'Lethargy Sayon +3',
            hands = 'Leth. Ganth. +3',
            -- 10 DT
            left_ring = 'Defending Ring',
            -- 10 DT
            right_ring = 'Murky Ring',
            legs = 'Leth. Fuseau +2',
            feet = 'Leth. Houseaux +3',
            -- 10 PDT
            back = SucellosCape.tp
        }
    )


-- Builds on the accuracy set to maximize spells that vary with potency using dMND
sets.midcast.enfeebling.potency  =
    set_combine(
        sets.midcast.enfeebling.accuracy,
        {
            range = empty,
            -- +7 MND, 10 effect. 20 macc lost
            ammo = 'Regal Gem',
            -- +16 MND. 13 macc lost
            head = 'Viti. Chapeau +4',
            -- Enfeeb effect +14
            body = 'Lethargy Sayon +3',
            -- +7 MND, 8 macc lost
            waist = 'Cascade Belt'
        }
    )

-- Same as the potency set, but blind uses dINT instead of dMND (technically INT - MND)
sets.midcast.enfeebling.blind    =
    set_combine(
        sets.midcast.enfeebling.accuracy,
        {
            -- +10 INT, -11 macc
            main = 'Naegling',
            -- +10 INT, -5 macc
            sub = 'Kaja Knife',
            range = empty,
            -- +10 effect, -20 macc
            ammo = 'Regal Gem',
            -- +11 INT, -6 macc
            head = 'Jhakri Coronal +2',
            -- +17 INT, -0 macc
            hands = 'Jhakri Cuffs +2',
            -- +33 INT, -8 macc
            feet = 'Jhakri Pigaches +2',
            -- +8 MND, -2 macc
            left_ear = 'Malignance Earring'
        }
    )

-- Frazzle wants a healthy mix of skill, effect, and accuracy, lastly MND
-- Frazzle skill caps at 625
-- The accuracy set is used as the base to help land this
sets.midcast.enfeebling.frazzle  =
    set_combine(
        sets.midcast.enfeebling.accuracy,
        {
            range = empty,
            -- +10 effect, -20 macc
            ammo = 'Regal Gem',
            body = 'Lethargy Sayon +3',
            -- +22 skill, -13 macc
            head = 'Viti. Chapeau +4'
        }
    )

-- Distract wants a healthy mix of skill, effect, and accuracy
-- Distract skill caps at 610
-- We can use the same set for both!
sets.midcast.enfeebling.distract = sets.midcast.enfeebling.frazzle

-- Poison is affected by enfeebling skill and effect, but not INT
-- Same as the frazzle set but with the duration set as the base
sets.midcast.enfeebling.poison   =
    set_combine(
        sets.midcast.enfeebling.duration,
        {
            range = empty,
            -- +10 effect, -20 macc
            ammo = 'Regal Gem',
            -- +22 skill, -13 macc
            head = 'Viti. Chapeau +4'
        }
    )

-- Gravity potency only effected by enfeebling effect stat, but not skill or INT
sets.midcast.enfeebling.gravity  =
    set_combine(
        sets.midcast.enfeebling.duration,
        {
            range = empty,
            -- +10 effect, -20 macc
            ammo = 'Regal Gem'
        }
    )



-- TODO: This set needs to be set_combine with another.
sets.midcast.enfeebling.saboteur    = {
    hands = 'Leth. Ganth. +3'
}

-- TODO: Use with a stance to swap in immunobreak gear
sets.midcast.enfeebling.immunobreak = {
    legs = { name = 'Chironic Hose', augments = { 'Pet: Phys. dmg. taken -4%', 'Mag. Acc.+14', 'Mag. Acc.+20 "Mag.Atk.Bns."+20', } },
}

-- Alias to allow referencing these sets using Gearswap's spell.skill
sets.midcast['Enfeebling Magic']    = sets.midcast.enfeebling
