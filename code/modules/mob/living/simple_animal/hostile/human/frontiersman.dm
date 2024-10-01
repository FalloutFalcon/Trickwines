/mob/living/simple_animal/hostile/human/frontier
	name = "Frontiersman"
	desc = "A frontiersman! A terrorist that would probably kill everyone without mercy."
	icon_state = "frontiersmanmelee"
	icon = 'icons/mob/simple_frontiersman.dmi'
	speak_chance = 0
	melee_damage_lower = 15
	melee_damage_upper = 15
	loot = list()
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	faction = list(FACTION_ANTAG_FRONTIERSMEN)
	footstep_type = FOOTSTEP_MOB_SHOE
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier
	r_hand = /obj/item/melee/knife/survival

/mob/living/simple_animal/hostile/human/frontier/internals
	icon_state = "frontiersmanmelee_mask"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/internals

/mob/living/simple_animal/hostile/human/frontier/ranged
	icon_state = "frontiersmanranged"
	ranged = 1
	retreat_distance = 5
	minimum_distance = 5
	projectilesound = 'sound/weapons/gun/revolver/cattleman.ogg'
	casingtype = /obj/item/ammo_casing/a44roum
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged
	r_hand = /obj/item/gun/ballistic/revolver/shadow

/mob/living/simple_animal/hostile/human/frontier/ranged/internals
	icon_state = "frontiersmanranged_mask"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/internals

/mob/living/simple_animal/hostile/human/frontier/ranged/internals/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/mosin
	icon_state = "frontiersmanrangedrifle"
	casingtype = /obj/item/ammo_casing/a8_50r
	projectilesound = 'sound/weapons/gun/rifle/mosin.ogg'
	r_hand = /obj/item/gun/ballistic/rifle/illestren

/mob/living/simple_animal/hostile/human/frontier/ranged/mosin/internals
	icon_state = "frontiersmanrangedrifle_mask"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/internals

/mob/living/simple_animal/hostile/human/frontier/ranged/mosin/internals/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/mosin/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper
	icon_state = "frontiersmanrangedelite"
	maxHealth = 170
	health = 170
	projectilesound = 'sound/weapons/gun/shotgun/shot.ogg'
	casingtype = /obj/item/ammo_casing/shotgun/buckshot
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/trooper
	r_hand = /obj/item/gun/ballistic/shotgun/brimstone

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/internals
	icon_state = "frontiersmanrangedelite_mask"
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/trooper/internals
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/internals/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/skm
	icon_state = "frontiersmanrangedak47"
	projectilesound = 'sound/weapons/gun/rifle/skm.ogg'
	rapid = 4
	rapid_fire_delay = 3
	casingtype = /obj/item/ammo_casing/a762_40
	r_hand = /obj/item/gun/ballistic/automatic/assault/skm

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/skm/internals
	icon_state = "frontiersmanrangedak47_mask"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/trooper/internals
	r_hand = /obj/item/gun/ballistic/automatic/assault/skm

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/skm/internals/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/skm/neutured
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/rifle
	icon_state = "frontiersmanrangedmosin"
	casingtype = /obj/item/ammo_casing/a8_50r
	projectilesound = 'sound/weapons/gun/rifle/mosin.ogg'
	r_hand = /obj/item/gun/ballistic/rifle/illestren

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/rifle/internals
	icon_state = "frontiersmanrangedmosin_mask"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/trooper/internals

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/rifle/internals/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/rifle/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/heavy
	icon_state = "frontiersmanrangedminigun"
	projectilesound = 'sound/weapons/laser4.ogg'
	maxHealth = 260
	health = 260
	rapid = 6
	rapid_fire_delay = 1.5
	casingtype = null
	projectiletype = /obj/projectile/beam/weak/penetrator
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/trooper/heavy

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/heavy/internals
	icon_state = "frontiersmanrangedminigun_mask"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/trooper/heavy/internals

/mob/living/simple_animal/hostile/human/frontier/ranged/trooper/heavy/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/officer
	name = "Frontiersman Officer"
	icon_state = "frontiersmanofficer"
	maxHealth = 65
	health = 65
	rapid = 4
	projectilesound = 'sound/weapons/gun/pistol/mauler.ogg'
	casingtype = /obj/item/ammo_casing/c9mm
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/officer
	r_hand = /obj/item/gun/ballistic/automatic/pistol/mauler

/mob/living/simple_animal/hostile/human/frontier/ranged/officer/internals
	icon_state = "frontiersmanofficer_mask"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	mob_spawner = /obj/effect/mob_spawn/human/corpse/frontier/ranged/officer/internals

/mob/living/simple_animal/hostile/human/frontier/ranged/officer/internals/neutered
	neutered = TRUE

/mob/living/simple_animal/hostile/human/frontier/ranged/officer/neutured
	neutered = TRUE
