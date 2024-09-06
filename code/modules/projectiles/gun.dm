/obj/item/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "flatgun"
	item_state = "gun"
	lefthand_file = GUN_LEFTHAND_ICON
	righthand_file = GUN_RIGHTHAND_ICON
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=2000)
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	force = 5
	item_flags = NEEDS_PERMIT
	attack_verb = list("struck", "hit", "bashed")
	pickup_sound = 'sound/items/handling/gun_pickup.ogg'
	drop_sound = 'sound/items/handling/gun_drop.ogg'
	//trigger guard on the weapon, hulks can't fire them with their big meaty fingers
	trigger_guard = TRIGGER_GUARD_NORMAL

	///The manufacturer of this weapon. For flavor mostly. If none, this will not show.
	var/manufacturer = MANUFACTURER_NONE

/*
 *  Muzzle
*/
	///Effect for the muzzle flash of the gun.
	var/obj/effect/muzzle_flash/muzzle_flash
	///Icon state of the muzzle flash effect.
	var/muzzleflash_iconstate
	///Brightness of the muzzle flash effect.
	var/muzzle_flash_lum = 3
	///Color of the muzzle flash effect.
	var/muzzle_flash_color = COLOR_VERY_SOFT_YELLOW

/*
 *  Firing
*/
	var/fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	var/vary_fire_sound = TRUE
	var/fire_sound_volume = 50
	var/dry_fire_sound = 'sound/weapons/gun/general/dry_fire.ogg'
	var/dry_fire_text = "click"

/*
 *  Reloading
*/
	var/obj/item/ammo_casing/chambered = null
	///Whether the gun can be tacloaded by slapping a fresh magazine directly on it
	var/tac_reloads = TRUE
	///If we have the 'snowflake mechanic,' how long should it take to reload?
	var/tactical_reload_delay = 1 SECONDS

	///Whether the gun has an internal magazine or a detatchable one. Overridden by BOLT_TYPE_NO_BOLT.
	var/internal_magazine = FALSE

	///Default magazine to spawn with.
	var/default_ammo_type = null
	///List of allowed specific types. If trying to reload with something in this list it will succeed. This is mainly for use in internal magazine weapons or scenarios where you do not want to inclue a whole subtype.
	var/list/allowed_ammo_types = list()

//BALLISTIC
	///Whether the gun alarms when empty or not.
	var/empty_alarm = FALSE

	///Actual magazine currently contained within the gun
	var/obj/item/ammo_box/magazine/magazine
	///whether the gun ejects the chambered casing
	var/casing_ejector = TRUE

	///Phrasing of the magazine in examine and notification messages; ex: magazine, box, etx
	var/magazine_wording = "magazine"
	///Phrasing of the cartridge in examine and notification messages; ex: bullet, shell, dart, etc.
	var/cartridge_wording = "bullet"

	///sound when inserting magazine
	var/load_sound = 'sound/weapons/gun/general/magazine_insert_full.ogg'
	///sound when inserting an empty magazine
	var/load_empty_sound = 'sound/weapons/gun/general/magazine_insert_empty.ogg'
	///volume of loading sound
	var/load_sound_volume = 40
	///whether loading sound should vary
	var/load_sound_vary = TRUE
	///Sound of ejecting a magazine
	var/eject_sound = 'sound/weapons/gun/general/magazine_remove_full.ogg'
	///sound of ejecting an empty magazine
	var/eject_empty_sound = 'sound/weapons/gun/general/magazine_remove_empty.ogg'
	///volume of ejecting a magazine
	var/eject_sound_volume = 40
	///whether eject sound should vary
	var/eject_sound_vary = TRUE

//ENERGY
	//What type of power cell this uses
	var/obj/item/stock_parts/cell/gun/installed_cell
	//Can it be charged in a recharger?
	var/can_charge = TRUE
	var/selfcharge = FALSE
	var/charge_tick = 0
	var/charge_delay = 4
	//whether the gun's cell drains the cyborg user's cell to recharge
	var/use_cyborg_cell = FALSE
	///Used for large and small cells
	var/mag_size = MAG_SIZE_MEDIUM
	//Time it takes to unscrew the cell
	var/unscrewing_time = 2 SECONDS

	var/list/ammo_type = list(/obj/item/ammo_casing/energy)
	//The state of the select fire switch. Determines from the ammo_type list what kind of shot is fired next.
	var/select = 1

/*
 *  Operation
*/
	//whether or not a message is displayed when fired
	var/suppressed = FALSE
	var/suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	var/suppressed_volume = 60

	//true if the gun is wielded via twohanded component, shouldnt affect anything else
	var/wielded = FALSE
	//true if the gun is wielded after delay, should affects accuracy
	var/wielded_fully = FALSE
	///Slowdown for wielding
	var/wield_slowdown = 0.1
	///How long between wielding and firing in tenths of seconds
	var/wield_delay	= 0.4 SECONDS
	///Storing value for above
	var/wield_time = 0

	///trigger guard on the weapon. Used for hulk mutations and ashies. I honestly dont know how usefult his is, id avoid touching it
	trigger_guard = TRIGGER_GUARD_NORMAL

	///Are we firing a burst? If so, dont fire again until burst is done
	var/currently_firing_burst = FALSE
	///This prevents gun from firing until the coodown is done, affected by lag
	var/current_cooldown = 0

	// BALLISTIC
	///Whether the gun has to be racked each shot or not.
	var/semi_auto = TRUE
	///The bolt type of the gun, affects quite a bit of functionality, see gun.dm in defines for bolt types: BOLT_TYPE_STANDARD; BOLT_TYPE_LOCKING; BOLT_TYPE_OPEN; BOLT_TYPE_NO_BOLT
	var/bolt_type = BOLT_TYPE_STANDARD
	///Used for locking bolt and open bolt guns. Set a bit differently for the two but prevents firing when true for both.
	var/bolt_locked = FALSE
	///Phrasing of the bolt in examine and notification messages; ex: bolt, slide, etc.
	var/bolt_wording = "bolt"
	///length between individual racks
	var/rack_delay = 5
	///time of the most recent rack, used for cooldown purposes
	var/recent_rack = 0

	///Whether the gun can be sawn off by sawing tools
	var/can_be_sawn_off = FALSE
	//description change if weapon is sawn-off
	var/sawn_desc = null
	var/sawn_off = FALSE

	///sound of racking
	var/rack_sound = 'sound/weapons/gun/general/bolt_rack.ogg'
	///volume of racking
	var/rack_sound_volume = 60
	///whether racking sound should vary
	var/rack_sound_vary = TRUE
	///sound of when the bolt is locked back manually
	var/lock_back_sound = 'sound/weapons/gun/general/slide_lock_1.ogg'
	///volume of lock back
	var/lock_back_sound_volume = 60
	///whether lock back varies
	var/lock_back_sound_vary = TRUE

	///sound of dropping the bolt or releasing a slide
	var/bolt_drop_sound = 'sound/weapons/gun/general/bolt_drop.ogg'
	///volume of bolt drop/slide release
	var/bolt_drop_sound_volume = 60
	///empty alarm sound (if enabled)
	var/empty_alarm_sound = 'sound/weapons/gun/general/empty_alarm.ogg'
	///empty alarm volume sound
	var/empty_alarm_volume = 70
	///whether empty alarm sound varies
	var/empty_alarm_vary = TRUE

/*
 *  Stats
*/
	var/weapon_weight = WEAPON_LIGHT
	//Alters projectile damage multiplicatively based on this value. Use it for "better" or "worse" weapons that use the same ammo.
	var/projectile_damage_multiplier = 1
	//Speed someone can be flung if its point blank
	var/pb_knockback = 0

	//Set to 0 for shotguns. This is used for weapons that don't fire all their bullets at once.
	var/randomspread = TRUE
	///How much the bullet scatters when fired while wielded.
	var/spread	= 4
	///How much the bullet scatters when fired while unwielded.
	var/spread_unwielded = 12
	//additional spread when dual wielding
	var/dual_wield_spread = 24
	var/gunslinger_spread_bonus = 0

	///Screen shake when the weapon is fired while wielded.
	var/recoil = 0
	///Screen shake when the weapon is fired while unwielded.
	var/recoil_unwielded = 0
	///a multiplier of the duration the recoil takes to go back to normal view, this is (recoil*recoil_backtime_multiplier)+1
	var/recoil_backtime_multiplier = 2
	///this is how much deviation the gun recoil can have, recoil pushes the screen towards the reverse angle you shot + some deviation which this is the max.
	var/recoil_deviation = 22.5
	///Used if the guns recoil is lower then the min, it clamps the highest recoil
	var/min_recoil = 0
	var/gunslinger_recoil_bonus = 0

	/// how many shots per burst, Ex: most machine pistols, M90, some ARs are 3rnd burst, while others like the GAR and laser minigun are 2 round burst.
	var/burst_size = 3
	///The rate of fire when firing in a burst. Not the delay between bursts
	var/burst_delay = 0.15 SECONDS
	///The rate of fire when firing full auto and semi auto, and between bursts; for bursts its fire delay + burst_delay after every burst
	var/fire_delay = 0.2 SECONDS
	//Prevent the weapon from firing again while already firing
	var/firing_burst = 0

/*
 *  Firemode
*/
	/// after initializing, we set the firemode to this
	var/default_firemode = FIREMODE_SEMIAUTO
	///Firemode index, due to code shit this is the currently selected firemode
	var/firemode_index
	/// Our firemodes, subtract and add to this list as needed. NOTE that the autofire component is given on init when FIREMODE_FULLAUTO is here.
	var/list/gun_firemodes = list(FIREMODE_SEMIAUTO, FIREMODE_BURST, FIREMODE_FULLAUTO, FIREMODE_OTHER, FIREMODE_OTHER_TWO)
	/// A acoc list that determines the names of firemodes. Use if you wanna be weird and set the name of say, FIREMODE_OTHER to "Underbarrel grenade launcher" for example.
	var/list/gun_firenames = list(FIREMODE_SEMIAUTO = "single", FIREMODE_BURST = "burst fire", FIREMODE_FULLAUTO = "full auto", FIREMODE_OTHER = "misc. fire", FIREMODE_OTHER_TWO = "very misc. fire")

	///BASICALLY: the little button you select firing modes from? this is jsut the prefix of the icon state of that. For example, if we set it as "laser", the fire select will use "laser_single" and so on.
	var/fire_select_icon_state_prefix = ""
	///If true, we put "safety_" before fire_select_icon_state_prefix's prefix. ex. "safety_laser_single"
	var/adjust_fire_select_icon_state_on_safety = FALSE

/*
 *  Overlay
*/
	///Used for positioning ammo count overlay on sprite
	var/ammo_x_offset = 0
	var/ammo_y_offset = 0
	var/ammo_overlay_sections = 5

//BALLISTIC
	///Whether the sprite has a visible magazine or not
	var/mag_display = FALSE
	///Whether the sprite has a visible ammo display or not
	var/mag_display_ammo = FALSE
	///Whether the sprite has a visible indicator for being empty or not.
	var/empty_indicator = FALSE
	///Whether the sprite has a visible magazine or not
	var/show_magazine_on_sprite = FALSE
	///Whether the sprite has a visible ammo display or not
	var/show_magazine_on_sprite_ammo = FALSE
	///Whether the gun supports multiple special mag types
	var/unique_mag_sprites_for_variants = FALSE

//ENERGY
	//Do we handle overlays with base update_appearance()?
	var/automatic_charge_overlays = TRUE
	//if this gun uses a stateful charge bar for more detail
	var/shaded_charge = FALSE
	//Modifies WHOS state //im SOMEWHAT this is wether or not the overlay changes based on the ammo type selected
	///If the type of ammo is added when making an overlay for ammo
	var/modifystate = TRUE

/*
 *  Attachment
*/
	///The types of attachments allowed, a list of types. SUBTYPES OF AN ALLOWED TYPE ARE ALSO ALLOWED
	var/list/valid_attachments = list()
	///Reference to our attachment holder to prevent subtypes having to call GetComponent
	var/datum/component/attachment_holder/attachment_holder
	///Number of attachments that can fit on a given slot
	var/list/slot_available = ATTACHMENT_DEFAULT_SLOT_AVAILABLE
	///Offsets for the slots on this gun. should be indexed by SLOT and then by X/Y
	var/list/slot_offsets = list()

/*
 *  Zooming
*/
	///Whether the gun generates a Zoom action on creation
	var/zoomable = FALSE
	//Zoom toggle
	var/zoomed = FALSE
	///Distance in TURFs to move the user's screen forward (the "zoom" effect)
	var/zoom_amt = 3
	var/zoom_out_amt = 0
	var/datum/action/toggle_scope_zoom/azoom

/*
 * Safety
*/
	///Does this gun have a saftey and thus can toggle it?
	var/has_safety = FALSE
	///If the saftey on? If so, we can't fire the weapon
	var/safety = FALSE
	///The wording of safety. Useful for guns that have a non-standard safety system, like a revolver
	var/safety_wording = "safety"

/*
 *  Spawn Info (Stuff that becomes useless onces the gun is spawned, mostly here for mappers)
*/
	///Attachments spawned on initialization. Should also be in valid attachments or it SHOULD(once i add that) fail
	var/list/default_attachments = list()
	///Spawns the mag emtpy
	var/spawn_empty_mag = FALSE

	var/gun_features_flags = GUN_AMMO_COUNTER
	var/reciever_flags = AMMO_RECIEVER_MAGAZINES


	var/default_cell_type = /obj/item/stock_parts/cell/gun
	var/list/allowed_cell_types = list()
	var/charge_sections = 3
	var/bullet_energy_cost = 0
	var/internal_cell = TRUE

/obj/item/gun/Initialize(mapload, spawn_empty)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))
	muzzle_flash = new(src, muzzleflash_iconstate)
	build_zooming()
	build_firemodes()

	if(spawn_empty || !default_ammo_type)
		update_icon()
		return
	INVOKE_ASYNC(src, PROC_REF(fill_gun))
	if(sawn_off)
		sawoff(forced = TRUE)
	if(selfcharge)
		START_PROCESSING(SSobj, src)

/obj/item/gun/proc/fill_gun()
	if(reciever_flags & AMMO_RECIEVER_CELL)
		if(default_ammo_type)
			installed_cell = new default_ammo_type(src)
		if(spawn_empty_mag)
			adjust_current_rounds(installed_cell, get_max_ammo(TRUE))
		update_ammo_types()
		recharge_newshot(TRUE)
		update_appearance()
	else
		if (!default_ammo_type && !ispath(default_ammo_type, /obj/item/ammo_box/magazine/internal))
			bolt_locked = TRUE
			update_appearance()
			return
		if (!magazine)
			magazine = new default_ammo_type(src)
		if (!default_ammo_type)
			get_ammo_list(drop_all = TRUE)
		if(default_cell_type && reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
			installed_cell = new default_cell_type(src)
		chamber_round()
		update_appearance()
	return

/obj/item/gun/proc/update_ammo_types()

/obj/item/gun/ComponentInitialize()
	. = ..()
	attachment_holder = AddComponent(/datum/component/attachment_holder, slot_available, valid_attachments, slot_offsets, default_attachments)
	AddComponent(/datum/component/two_handed)

/// triggered on wield of two handed item
/obj/item/gun/proc/on_wield(obj/item/source, mob/user)
	wielded = TRUE
	INVOKE_ASYNC(src, .proc.do_wield, user)

/obj/item/gun/proc/do_wield(mob/user)
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/gun, multiplicative_slowdown = wield_slowdown)
	wield_time = world.time + wield_delay
	if(wield_time > 0)
		if(do_after(
			user,
			wield_delay,
			user,
			FALSE,
			TRUE,
			CALLBACK(src, PROC_REF(is_wielded)),
			timed_action_flags = IGNORE_USER_LOC_CHANGE
			)
			)
			wielded_fully = TRUE
			return TRUE
	else
		wielded_fully = TRUE
		return TRUE

/obj/item/gun/proc/is_wielded()
	return wielded

/// triggered on unwield of two handed item
/obj/item/gun/proc/on_unwield(obj/item/source, mob/user)
	wielded = FALSE
	wielded_fully = FALSE
	zoom(user, forced_zoom = FALSE)
	user.remove_movespeed_modifier(/datum/movespeed_modifier/gun)

/obj/item/gun/Destroy()
	if(chambered) //Not all guns are chambered (EMP'ed energy guns etc)
		QDEL_NULL(chambered)
	if(azoom)
		QDEL_NULL(azoom)
	if(muzzle_flash)
		QDEL_NULL(muzzle_flash)
	return ..()

/obj/item/gun/handle_atom_del(atom/A)
	if(A == chambered)
		chambered = null
		update_icon()
	return ..()

/obj/item/gun/examine(mob/user)
	. = ..()
	if(manufacturer)
		. += "It has <b>[manufacturer]</b> engraved on it."
	if(has_safety)
		. += "The safety is [safety ? span_green("ON") : span_red("OFF")]. [span_info("<b>Ctrl-click</b> to toggle the safety.")]"
	if(reciever_flags & AMMO_RECIEVER_CELL)
		var/obj/item/ammo_casing/energy/shot = ammo_type[select]
		if(installed_cell)
			. += "It is on <b>[shot.select_name]</b> mode."
			if(ammo_type.len > 1)
				. += "You can switch firemodes by pressing the <b>unique action</b> key. By default, this is <b>space</b>."
		else
			. += "It doesn't seem to have a cell!"
	else
		if (bolt_locked)
			. += "The [bolt_wording] is locked back and needs to be released before firing."
		. += span_info("You can [bolt_wording] it by pressing the <b>unique action</b> key. By default, this is <b>space</b.>")
	. += examine_ammo_count(user)

/obj/item/gun/proc/examine_ammo_count(mob/user)
	var/list/dat = list()
	if(get_max_ammo(TRUE) > 0)
		if(gun_features_flags & GUN_AMMO_COUNTER)
			if(get_max_ammo(TRUE) && gun_features_flags & GUN_AMMO_COUNT_BY_PERCENTAGE)
				dat += "It has [round((get_ammo_count(TRUE) / get_max_ammo(TRUE)) * 100)]% remaining."
			else if(get_max_ammo(TRUE) && gun_features_flags & GUN_AMMO_COUNT_BY_SHOTS_REMAINING)
				dat += "It has [round(get_ammo_count(TRUE) / get_rounds_per_shot())] shots remaining."
			else
				dat += "It has [get_ammo_count(TRUE)] round\s remaining."
		else
			dat += "It's loaded[chambered?" and has a round chambered":""]."
	else
		dat += "It's unloaded[chambered?" but has a round chambered":""]."
	if(reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
		if(installed_cell)
			dat += "It's secondary cell has [round(installed_cell.charge / installed_cell.maxcharge * 100)]% remaining."
		else
			dat += "It doesn't seem to have a secondary cell!"
	return dat

/obj/item/gun/attackby(obj/item/A, mob/user, params)
	. = ..()
	if (.)
		return
	if(reload(A, user, params))
		return
	if (can_be_sawn_off)
		if (try_sawoff(user, A))
			return
	return FALSE

/obj/item/gun/equipped(mob/living/user, slot)
	. = ..()
	if(zoomed && user.get_active_held_item() != src)
		zoom(user, user.dir, FALSE) //we can only stay zoomed in if it's in our hands	//yeah and we only unzoom if we're actually zoomed using the gun!!

/obj/item/gun/attack(mob/M as mob, mob/user)
	if(user.a_intent == INTENT_HARM) //Flogging
		return ..()
	return

//called after the gun has successfully fired its chambered ammo.
/obj/item/gun/proc/process_chamber(atom/shooter, empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	if(!semi_auto && from_firing)
		return
	var/obj/item/ammo_casing/casing = chambered //Find chambered round
	if(istype(casing)) //there's a chambered round
		if(casing_ejector || !from_firing)
			casing.on_eject(shooter)
			chambered = null
		else if(empty_chamber)
			chambered = null
	if (chamber_next_round && (magazine?.max_ammo > 1))
		chamber_round()
	SEND_SIGNAL(src, COMSIG_GUN_CHAMBER_PROCESSED)

///Used to chamber a new round and eject the old one
/obj/item/gun/proc/chamber_round(keep_bullet = FALSE)
	if (chambered || !magazine)
		return
	if (magazine.ammo_count())
		chambered = magazine.get_round(keep_bullet || bolt_type == BOLT_TYPE_NO_BOLT)
		if (bolt_type != BOLT_TYPE_OPEN)
			chambered.forceMove(src)

///updates a bunch of racking related stuff and also handles the sound effects and the like
/obj/item/gun/proc/rack(mob/user = null, chamber_new_round = TRUE)
	if (bolt_type == BOLT_TYPE_NO_BOLT) //If there's no bolt, nothing to rack
		return
	if (bolt_type == BOLT_TYPE_OPEN)
		if(!bolt_locked)	//If it's an open bolt, racking again would do nothing
			if (user)
				to_chat(user, "<span class='notice'>\The [src]'s [bolt_wording] is already cocked!</span>")
			return
		bolt_locked = FALSE
	if (user)
		to_chat(user, "<span class='notice'>You rack the [bolt_wording] of \the [src].</span>")
	process_chamber(user, !chambered, FALSE, chamber_new_round)
	if ((bolt_type == BOLT_TYPE_LOCKING && !chambered) || bolt_type == BOLT_TYPE_CLIP)
		bolt_locked = TRUE
		playsound(src, lock_back_sound, lock_back_sound_volume, lock_back_sound_vary)
	else
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)

	SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)

/obj/item/gun/proc/drop_bolt(mob/user = null, chamber_new_round = TRUE)
	playsound(src, bolt_drop_sound, bolt_drop_sound_volume, FALSE)
	if (user)
		to_chat(user, "<span class='notice'>You drop the [bolt_wording] of \the [src].</span>")
	if(chamber_new_round)
		chamber_round()
	bolt_locked = FALSE
	update_appearance()

//check if there's enough ammo/energy/whatever to shoot one time
//i.e if clicking would make it shoot
/obj/item/gun/proc/can_shoot()
	if(reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
		if(QDELETED(installed_cell))
			return FALSE
		var/obj/item/ammo_casing/caseless/gauss/shot = chambered
		if(!shot)
			return FALSE
		if(installed_cell.charge < shot.energy_cost * burst_size)
			return FALSE

	if(safety)
		return FALSE
	if(!(reciever_flags & AMMO_RECIEVER_CYCLE_ONLY_BEFORE_FIRE))
		return chambered
	return TRUE

/obj/item/gun/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		for(var/obj/O in contents)
			O.emp_act(severity)

/obj/item/gun/proc/recharge_newshot()
	return

/obj/item/gun/afterattack(atom/target, mob/living/user, flag, params)
	. = ..()
	//No target? Why are we even firing anyways...
	if(!target)
		return
	//If we are burst firing, don't fire, obviously
	if(currently_firing_burst)
		return
	//This var happens when we are either clicking someone next to us or ourselves. Check if we don't want to fire...
	if(flag)
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target) || user.a_intent == INTENT_HARM) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH) //so we can't shoot ourselves (unless mouth selected)
			return
/* TODO: gunpointing is very broken, port the old skyrat gunpointing? its much better, usablity wise and rp wise?
		if(ismob(target) && user.a_intent == INTENT_GRAB)
			if(user.GetComponent(/datum/component/gunpoint))
				to_chat(user, "<span class='warning'>You are already holding someone up!</span>")
				return
			user.AddComponent(/datum/component/gunpoint, target, src)
			return
*/
	// Good job, but we have exta checks to do...
	return pre_fire(target, user, TRUE, flag, params, null)

///Prefire empty checks for the bolt drop
/obj/item/gun/proc/prefire_empty_checks()
	if (!chambered && !get_ammo_count())
		if (bolt_type == BOLT_TYPE_OPEN && !bolt_locked)
			bolt_locked = TRUE
			playsound(src, bolt_drop_sound, bolt_drop_sound_volume)
			update_appearance()

///postfire empty checks for bolt locking and sound alarms
/obj/item/gun/proc/postfire_empty_checks(last_shot_succeeded)
	if (!chambered && !get_ammo_count())
		if (last_shot_succeeded)
			if (empty_alarm)
				playsound(src, empty_alarm_sound, empty_alarm_volume, empty_alarm_vary)
				update_appearance()
			if (reciever_flags & AMMO_RECIEVER_AUTO_EJECT && !internal_magazine)
				eject_mag(display_message = FALSE)
				update_appearance()
			if (bolt_type == BOLT_TYPE_LOCKING)
				bolt_locked = TRUE
				update_appearance()
			if (bolt_type == BOLT_TYPE_CLIP)
				update_appearance()

/obj/item/gun/proc/pre_fire(atom/target, mob/living/user,  message = TRUE, flag, params = null, zone_override = "", bonus_spread = 0, dual_wielded_gun = FALSE)
	prefire_empty_checks()

	add_fingerprint(user)

	// If we have a cooldown, don't do anything, obviously
	if(current_cooldown)
		return

	//We check if the user can even use the gun, if not, we assume the user isn't alive(turrets) so we go ahead.
	if(istype(user))
		var/mob/living/living_user = user
		if(!can_trigger_gun(living_user))
			return

	//If targetting the mouth, we do suicide instead.
	if(flag)
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
			handle_suicide(user, target, params)
			return

	//Just because we can pull the trigger doesn't mean it can fire. Mostly for safties.
	if(!can_shoot())
		shoot_with_empty_chamber(user)
		return

	//we then check our weapon weight vs if we are being wielded...
	if(weapon_weight == WEAPON_VERY_HEAVY && (!wielded_fully))
		to_chat(user, "<span class='warning'>You need a fully secure grip to fire [src]!</span>")
		return

	if(weapon_weight == WEAPON_HEAVY && (!wielded))
		to_chat(user, "<span class='warning'>You need a more secure grip to fire [src]!</span>")
		return
	//If we have the pacifist trait and a chambered round, don't fire. Honestly, pacifism quirk is pretty stupid, and as such we check again in process_fire() anyways
	if(chambered)
		if(HAS_TRAIT(user, TRAIT_PACIFISM)) // If the user has the pacifist trait, then they won't be able to fire [src] if the round chambered inside of [src] is lethal.
			if(chambered.harmful) // Is the bullet chambered harmful?
				to_chat(user, "<span class='warning'>[src] is lethally chambered! You don't want to risk harming anyone...</span>")
				return

	//Dual wielding handling. Not the biggest fan of this, but it's here. Dual berettas not included
	var/loop_counter = 0
	if(ishuman(user) && user.a_intent == INTENT_HARM && !dual_wielded_gun)
		var/mob/living/carbon/human/our_cowboy = user
		for(var/obj/item/gun/found_gun in our_cowboy.held_items)
			if(found_gun == src || found_gun.weapon_weight >= WEAPON_MEDIUM)
				continue
			else if(found_gun.can_trigger_gun(user))
				bonus_spread += dual_wield_spread
				loop_counter++
				addtimer(CALLBACK(found_gun, TYPE_PROC_REF(/obj/item/gun, pre_fire), target, user, TRUE, params, null, bonus_spread), loop_counter)

	//get current firemode
	var/current_firemode = gun_firemodes[firemode_index]
	//FIREMODE_OTHER and its sister directs you to another proc for special handling
	if(current_firemode == FIREMODE_OTHER)
		return process_other(target, user, message, flag, params, zone_override, bonus_spread)
	if(current_firemode == FIREMODE_OTHER_TWO)
		return process_other_two(target, user, message, flag, params, zone_override, bonus_spread)

	//if all of that succeded, we finally get to process firing
	return process_fire(target, user, TRUE, params, null, bonus_spread)

/obj/item/gun/proc/process_other(atom/target, mob/living/user, message = TRUE, flag, params = null, zone_override = "", bonus_spread = 0)
	return //use this for 'underbarrels!!

/obj/item/gun/proc/process_other_two(atom/target, mob/living/user, message = TRUE, flag, params = null, zone_override = "", bonus_spread = 0)
	return //reserved in case another fire mode is needed, if you need special behavior, put it here then call process_fire, or call process_fire and have the special behavior there

/**
 * Handles everything involving firing.
 * * gun.dm is still a fucking mess, and I will document everything next time i get to it... for now this will suffice.
 *
 * Returns TRUE or FALSE depending on if it actually fired a shot.
 * Arguments:
 * * target - The atom we are trying to hit.
 * * user - The living mob firing the gun, if any.
 * * message - Do we show the usual messages? eg. "x fires the y!"
 * * params - Is the params string from byond [/atom/proc/Click] code, see that documentation.
 * * zone_override - The bodypart we attempt to hit, sometimes hits another.
 * * bonus_spread - Adds this value to spread, in this case used by dual wielding.
 * * burst_firing - Not to be confused with currently_firing_burst. This var is TRUE when we are doing a burst except for the first shot in a burst, as to override the spam burst checks.
 * * spread_override - Bullet spread is forcibly set to this. This is usually because of bursts attempting to share the same burst trajectory.
 * * iteration - Which shot in a burst are we in.
 */
/obj/item/gun/proc/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, burst_firing = FALSE, spread_override = 0, iteration = 0)
	//OKAY, this prevents us from firing until our cooldown is done
	if(!burst_firing) //if we're firing a burst, dont interfere to avoid issues
		if(current_cooldown)
			return FALSE

	//Check one last time for safeties...
	if(!can_shoot())
		shoot_with_empty_chamber(user)
		currently_firing_burst = FALSE
		return FALSE

	//special hahnding for burst firing
	if(burst_firing)
		if(!user || !currently_firing_burst)
			currently_firing_burst = FALSE
			return FALSE
		if(!issilicon(user))
			//If we aren't holding the gun, what are we doing, stop firing!
			if(iteration > 1 && !(user.is_holding(src)))
				currently_firing_burst = FALSE
				return FALSE

	//Do we have a round? If not, stop the whole chain, and if we do, check if the gun is chambered. Pacisim is pretty lame anyways.
	if(chambered)
		if(HAS_TRAIT(user, TRAIT_PACIFISM)) // If the user has the pacifist trait, then they won't be able to fire [src] if the round chambered inside of [src] is lethal.
			if(chambered.harmful) // Is the bullet chambered harmful?
				to_chat(user, "<span class='warning'>[src] is lethally chambered! You don't want to risk harming anyone...</span>")
				currently_firing_burst = FALSE //no burst 4 u
				return FALSE
	else
		shoot_with_empty_chamber(user)
		currently_firing_burst = FALSE
		return FALSE

	// we hold the total spread in this var
	var/sprd
	// if we ARE burst firing and don't have "randomspread", we add the burst's penalty on top of it.
	if(burst_firing && !randomspread)
		bonus_spread += burst_size * iteration

	//override spread? usually happens only in bursts
	if(spread_override && !randomspread)
		sprd = spread_override
	else
		//Calculate spread
		sprd = calculate_spread(user, bonus_spread)

	before_firing(target,user)
	//If we cant fire the round, just end the proc here. Otherwise, continue
	if(!chambered.fire_casing(target, user, params, , suppressed, zone_override, sprd, src))
		shoot_with_empty_chamber(user)
		currently_firing_burst = FALSE
		return FALSE
	//Are we PBing someone? If so, set pointblank to TRUE
	shoot_live_shot(user, (get_dist(user, target) <= 1), target, message) //Making sure whether the target is in vicinity for the pointblank shot

	//process the chamber...
	process_chamber(user)
	update_appearance()
	//get our current firemode...
	var/current_firemode = gun_firemodes[firemode_index]

	//If we are set to burst fire, then we burst fire!
	if(burst_size > 1 && (current_firemode == FIREMODE_BURST) && !burst_firing)
		currently_firing_burst = TRUE
		for(var/i = 2 to burst_size) //we fire the first burst normally, hence why its 2
			addtimer(CALLBACK(src, PROC_REF(process_fire), target, user, message, params, zone_override, 0, TRUE, sprd, i), burst_delay * (i - 1))

	//if we have a fire delay, set up a cooldown
	if(fire_delay && (!burst_firing && !currently_firing_burst))
		current_cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_current_cooldown)), fire_delay)
	if(burst_firing && iteration >= burst_size)
		current_cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_current_cooldown)), fire_delay+burst_delay)
		currently_firing_burst = FALSE

	// update our inhands...
	if(user)
		user.update_inv_hands()

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE

/obj/item/gun/proc/reset_current_cooldown()
	current_cooldown = FALSE

/obj/item/gun/proc/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(!safety)
		to_chat(user, "<span class='danger'>*[dry_fire_text]*</span>")
		playsound(src, dry_fire_sound, 30, TRUE)
		return
	to_chat(user, "<span class='danger'>Safeties are active on the [src]! Turn them off to fire!</span>")


/obj/item/gun/proc/shoot_live_shot(mob/living/user, pointblank = FALSE, atom/pbtarget = null, message = TRUE)
	if(reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
		installed_cell.use(bullet_energy_cost)

	var/actual_angle = get_angle_with_scatter((user || get_turf(src)), pbtarget, rand(-recoil_deviation, recoil_deviation) + 180)
	var/muzzle_angle = Get_Angle(get_turf(src), pbtarget)

	user.changeNext_move(clamp(fire_delay, 0, CLICK_CD_RANGE))

	if(muzzle_flash && !muzzle_flash.applied)
		handle_muzzle_flash(user, muzzle_angle)

	if(wielded_fully)
		simulate_recoil(user, recoil, actual_angle)
	else if(!wielded_fully)
		simulate_recoil(user, recoil_unwielded, actual_angle)

	if(suppressed)
		playsound(user, suppressed_sound, suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
	else
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		if(message)
			if(pointblank)
				user.visible_message(
						span_danger("[user] fires [src] point blank at [pbtarget]!"),
						span_danger("You fire [src] point blank at [pbtarget]!"),
						span_hear("You hear a gunshot!"), COMBAT_MESSAGE_RANGE, pbtarget
				)
				to_chat(pbtarget, "<span class='userdanger'>[user] fires [src] point blank at you!</span>")
				if(pb_knockback > 0 && ismob(pbtarget))
					var/mob/PBT = pbtarget
					var/atom/throw_target = get_edge_target_turf(PBT, user.dir)
					PBT.throw_at(throw_target, pb_knockback, 2)
			else
				user.visible_message(
						span_danger("[user] fires [src]!"),
						blind_message = span_hear("You hear a gunshot!"),
						vision_distance = COMBAT_MESSAGE_RANGE,
						ignored_mobs = user
				)
	try_lesbian(user)

/obj/item/gun/proc/try_lesbian(mob/living/user)
	//cloudy sent a meme in the discord. i dont know if its true, but i made this piece of code in honor of it
	var/mob/living/carbon/human/living_human = user
	if(istype(living_human))
		if(!living_human.wear_neck)
			return //if nothing on the neck, don't do anything
		var/current_month = text2num(time2text(world.timeofday, "MM"))
		var/static/regex/bian = regex("(?:^\\W*lesbian)", "i")

		if(current_month == JUNE)
			return //if it isn't june, don't do this easter egg

		if(!findtext(bian, living_human.generic_adjective))
			return //dont bother if we already are affected by it

		if(istype(living_human.wear_neck, /obj/item/clothing/neck/tie/lesbian) || living_human.wear_neck.icon_state == "lesbian")
			var/use_space = "[living_human.generic_adjective ? " " : ""]"
			living_human.generic_adjective = "lesbian[use_space][living_human.generic_adjective]" //i actually don't remember the meme. it was something like lesbians will stop working if they see another with a gun. or something.

/obj/item/gun/CtrlClick(mob/user)
	. = ..()
	if(!has_safety)
		return

	if(src != user.get_active_held_item())
		return

	if(isliving(user) && in_range(src, user))
		toggle_safety(user)

/obj/item/gun/proc/toggle_safety(mob/user, silent=FALSE)
	safety = !safety

	if(!silent)
		playsound(user, 'sound/weapons/gun/general/selector.ogg', 100, TRUE)
		user.visible_message(
			span_notice("[user] turns the [safety_wording] on [src] [safety ? "<span class='green'>ON</span>" : "<span class='red'>OFF</span>"]."),
			span_notice("You turn the [safety_wording] on [src] [safety ? "<span class='green'>ON</span>" : "<span class='red'>OFF</span>"]."),
		)

	update_appearance()

/obj/item/gun/attack_hand(mob/user)
	if(reciever_flags & AMMO_RECIEVER_CELL)
		if(!internal_magazine && loc == user && user.is_holding(src) && installed_cell && tac_reloads)
			eject_mag(user)
			return
	if(reciever_flags & AMMO_RECIEVER_MAGAZINES)
		if(!internal_magazine && loc == user && user.is_holding(src) && magazine)
			eject_mag(user)
			return
	. = ..()
	update_appearance()

/obj/item/gun/pickup(mob/user)
	. = ..()
	update_appearance()
	if(azoom)
		azoom.Grant(user)

/obj/item/gun/dropped(mob/user)
	. = ..()
	update_appearance()
	if(azoom)
		azoom.Remove(user)
	if(zoomed)
		zoom(user, user.dir)

/obj/item/gun/update_icon_state()
	if(reciever_flags & AMMO_RECIEVER_CELL)
		if(initial(item_state))
			return ..()
		var/ratio = get_charge_ratio()
		var/new_item_state = ""
		new_item_state = initial(icon_state)
		if(modifystate)
			var/obj/item/ammo_casing/energy/shot = ammo_type[select]
			new_item_state += "[shot.select_name]"
		new_item_state += "[ratio]"
		item_state = new_item_state
		return ..()

	if(current_skin)
		icon_state = "[unique_reskin[current_skin]][sawn_off ? "_sawn" : ""]"
	else
		icon_state = "[base_icon_state || initial(icon_state)][sawn_off ? "_sawn" : ""]"
	return ..()

/obj/item/gun/update_overlays()
	. = ..()
	if(ismob(loc) && has_safety)
		var/mutable_appearance/safety_overlay
		safety_overlay = mutable_appearance('icons/obj/guns/safety.dmi')
		if(safety)
			safety_overlay.icon_state = "[safety_wording]-on"
		else
			safety_overlay.icon_state = "[safety_wording]-off"
		. += safety_overlay
	if(reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
		if(!automatic_charge_overlays)
			return
		var/overlay_icon_state = "[icon_state]_charge"
		var/charge_ratio = get_charge_ratio()
		if(installed_cell)
			. += "[icon_state]_cell"
		if(charge_ratio == 0)
			. += "[icon_state]_cellempty"
		else
			if(!shaded_charge)
				var/mutable_appearance/charge_overlay = mutable_appearance(icon, overlay_icon_state)
				for(var/i in 1 to charge_ratio)
					charge_overlay.pixel_x = ammo_x_offset * (i - 1)
					charge_overlay.pixel_y = ammo_y_offset * (i - 1)
					. += new /mutable_appearance(charge_overlay)
			else
				. += "[icon_state]_charge[charge_ratio]"

	if(reciever_flags & AMMO_RECIEVER_CELL)
		if(!automatic_charge_overlays || QDELETED(src))
			return
		// Every time I see code this "flexible", a kitten fucking dies //it got worse
		//todo: refactor this a bit to allow showing of charge on a gun's cell
		var/overlay_icon_state = "[icon_state]_charge"
		var/obj/item/ammo_casing/energy/shot = ammo_type[modifystate ? select : 1]
		var/ratio = get_charge_ratio()
		if(installed_cell)
			. += "[icon_state]_cell"
			if(ratio == 0)
				. += "[icon_state]_cellempty"
		if(ratio == 0)
			if(modifystate)
				. += "[icon_state]_[shot.select_name]"
			. += "[icon_state]_empty"
		else
			if(!shaded_charge)
				if(modifystate)
					. += "[icon_state]_[shot.select_name]"
					overlay_icon_state += "_[shot.select_name]"
				var/mutable_appearance/charge_overlay = mutable_appearance(icon, overlay_icon_state)
				for(var/i = ratio, i >= 1, i--)
					charge_overlay.pixel_x = ammo_x_offset * (i - 1)
					charge_overlay.pixel_y = ammo_y_offset * (i - 1)
					. += new /mutable_appearance(charge_overlay)
			else
				if(modifystate)
					. += "[icon_state]_charge[ratio]_[shot.select_name]" //:drooling_face:
				else
					. += "[icon_state]_charge[ratio]"
		return

	if (bolt_type == BOLT_TYPE_LOCKING)
		. += "[icon_state]_bolt[bolt_locked ? "_locked" : ""]"
	if (bolt_type == BOLT_TYPE_OPEN && bolt_locked)
		. += "[icon_state]_bolt"
	if (magazine)
		if (unique_mag_sprites_for_variants)
			. += "[icon_state]_mag_[magazine.base_icon_state]"
			if (!get_ammo_count(countchambered = FALSE))
				. += "[icon_state]_mag_empty"
		else
			. += "[icon_state]_mag"
			var/capacity_number = 0
			capacity_number = ROUND_UP((get_ammo_count() / get_max_ammo()) * ammo_overlay_sections)
			if (capacity_number)
				. += "[icon_state]_mag_[capacity_number]"
	if(!chambered && empty_indicator)
		. += "[icon_state]_empty"
	if(chambered && mag_display_ammo)
		. += "[icon_state]_chambered"

#define BRAINS_BLOWN_THROW_RANGE 2
#define BRAINS_BLOWN_THROW_SPEED 1

/obj/item/gun/proc/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(current_cooldown)
		return

	if(!can_shoot()) //Just because you can pull the trigger doesn't mean it can shoot.
		shoot_with_empty_chamber(user)
		return

	if(user == target)
		target.visible_message(span_warning("[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger..."), \
			span_userdanger("You stick [src] in your mouth, ready to pull the trigger..."))
	else
		target.visible_message(span_warning("[user] points [src] at [target]'s head, ready to pull the trigger..."), \
			span_userdanger("[user] points [src] at your head, ready to pull the trigger..."))

	current_cooldown = TRUE

	if(!bypass_timer && (!do_after(user, 100, target) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message(span_notice("[user] decided not to shoot."))
			else if(target && target.Adjacent(user))
				target.visible_message(span_notice("[user] has decided to spare [target]."), span_notice("[user] has decided to spare your life!"))
		current_cooldown = FALSE
		return

	current_cooldown = FALSE

	target.visible_message(span_warning("[user] pulls the trigger!"), span_userdanger("[(user == target) ? "You pull" : "[user] pulls"] the trigger!"))

	if(chambered && chambered.BB && can_trigger_gun(user))
		chambered.BB.damage *= 3
		//Check is here for safeties and such, brain will be removed after
		if(!pre_fire(target, user, TRUE, FALSE, params, BODY_ZONE_HEAD)) // We're already in handle_suicide, hence the 4th parameter needs to be FALSE to avoid circular logic. Also, BODY_ZONE_HEAD because we want to damage the head as a whole.
			return

		var/obj/item/organ/brain/brain_to_blast = target.getorganslot(ORGAN_SLOT_BRAIN)
		if(brain_to_blast)

			//Check if the projectile is actually damaging and not of type STAMINA
			if(chambered.BB.nodamage || !chambered.BB.damage || chambered.BB.damage_type == STAMINA)
				return

			//Remove brain of the mob shot
			brain_to_blast.Remove(target)

			var/turf/splat_turf = get_turf(target)
			//Move the brain of the person shot to selected turf
			brain_to_blast.forceMove(splat_turf)

			var/turf/splat_target = get_ranged_target_turf(target, REVERSE_DIR(target.dir), BRAINS_BLOWN_THROW_RANGE)
			var/datum/callback/gibspawner = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(spawn_atom_to_turf), /obj/effect/gibspawner/generic, brain_to_blast, 1, FALSE, target)
			//Throw the brain that has been removed away and place a gibspawner on landing
			brain_to_blast.throw_at(splat_target, BRAINS_BLOWN_THROW_RANGE, BRAINS_BLOWN_THROW_SPEED, callback = gibspawner)

#undef BRAINS_BLOWN_THROW_RANGE
#undef BRAINS_BLOWN_THROW_SPEED

//Happens before the actual projectile creation
/obj/item/gun/proc/before_firing(atom/target,mob/user)
	if(reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
		var/obj/item/ammo_casing/caseless/gauss/shot = chambered
		if(shot?.energy_cost)
			bullet_energy_cost = shot.energy_cost

/obj/item/gun/proc/calculate_recoil(mob/user, recoil_bonus = 0)
	if(HAS_TRAIT(user, TRAIT_GUNSLINGER))
		recoil_bonus += gunslinger_recoil_bonus
	return clamp(recoil_bonus, min_recoil , INFINITY)

/obj/item/gun/proc/calculate_spread(mob/user, bonus_spread)
	var/final_spread = 0
	var/randomized_gun_spread = 0
	var/randomized_bonus_spread = 0

	final_spread += bonus_spread

	if(HAS_TRAIT(user, TRAIT_GUNSLINGER))
		randomized_bonus_spread += rand(0, gunslinger_spread_bonus)

	if(HAS_TRAIT(user, TRAIT_POOR_AIM))
		randomized_bonus_spread += rand(0, 25)

	//We will then calculate gun spread depending on if we are fully wielding (after do_after) the gun or not
	randomized_gun_spread =	rand(0, wielded_fully ? spread : spread_unwielded)

	final_spread += randomized_gun_spread + randomized_bonus_spread

	//Clamp it down to avoid guns with negative spread to have worse recoil...
	final_spread = clamp(final_spread, 0, INFINITY)

	//So spread isn't JUST to the right
	if(prob(50))
		final_spread *= -1

	final_spread = round(final_spread)

	return final_spread

/obj/item/gun/proc/simulate_recoil(mob/living/user, recoil_bonus = 0, firing_angle)
	var/total_recoil = calculate_recoil(user, recoil_bonus)

	var/actual_angle = firing_angle + rand(-recoil_deviation, recoil_deviation) + 180
	if(actual_angle > 360)
		actual_angle -= 360
	if(total_recoil > 0)
		recoil_camera(user, total_recoil + 1, (total_recoil * recoil_backtime_multiplier)+1, total_recoil, actual_angle)
		return TRUE

/obj/item/gun/proc/handle_muzzle_flash(mob/living/user, firing_angle)
	var/atom/movable/flash_loc = user
	var/prev_light = light_range

	if(!light_on && (light_range <= muzzle_flash_lum))
		set_light_range(muzzle_flash_lum)
		set_light_color(muzzle_flash_color)
		set_light_on(TRUE)
		update_light()
		addtimer(CALLBACK(src, PROC_REF(reset_light_range), prev_light), 1 SECONDS)
	//Offset the pixels.
	switch(firing_angle)
		if(0, 360)
			muzzle_flash.pixel_x = 0
			muzzle_flash.pixel_y = 8
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(1 to 44)
			muzzle_flash.pixel_x = round(4 * ((firing_angle) / 45))
			muzzle_flash.pixel_y = 8
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(45)
			muzzle_flash.pixel_x = 8
			muzzle_flash.pixel_y = 8
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(46 to 89)
			muzzle_flash.pixel_x = 8
			muzzle_flash.pixel_y = round(4 * ((90 - firing_angle) / 45))
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(90)
			muzzle_flash.pixel_x = 8
			muzzle_flash.pixel_y = 0
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(91 to 134)
			muzzle_flash.pixel_x = 8
			muzzle_flash.pixel_y = round(-3 * ((firing_angle - 90) / 45))
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(135)
			muzzle_flash.pixel_x = 8
			muzzle_flash.pixel_y = -6
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(136 to 179)
			muzzle_flash.pixel_x = round(4 * ((180 - firing_angle) / 45))
			muzzle_flash.pixel_y = -6
			muzzle_flash.layer = ABOVE_MOB_LAYER
		if(180)
			muzzle_flash.pixel_x = 0
			muzzle_flash.pixel_y = -6
			muzzle_flash.layer = ABOVE_MOB_LAYER
		if(181 to 224)
			muzzle_flash.pixel_x = round(-6 * ((firing_angle - 180) / 45))
			muzzle_flash.pixel_y = -6
			muzzle_flash.layer = ABOVE_MOB_LAYER
		if(225)
			muzzle_flash.pixel_x = -6
			muzzle_flash.pixel_y = -6
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(226 to 269)
			muzzle_flash.pixel_x = -6
			muzzle_flash.pixel_y = round(-6 * ((270 - firing_angle) / 45))
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(270)
			muzzle_flash.pixel_x = -6
			muzzle_flash.pixel_y = 0
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(271 to 314)
			muzzle_flash.pixel_x = -6
			muzzle_flash.pixel_y = round(8 * ((firing_angle - 270) / 45))
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(315)
			muzzle_flash.pixel_x = -6
			muzzle_flash.pixel_y = 8
			muzzle_flash.layer = initial(muzzle_flash.layer)
		if(316 to 359)
			muzzle_flash.pixel_x = round(-6 * ((360 - firing_angle) / 45))
			muzzle_flash.pixel_y = 8
			muzzle_flash.layer = initial(muzzle_flash.layer)

	muzzle_flash.transform = null
	muzzle_flash.transform = turn(muzzle_flash.transform, firing_angle)
	flash_loc.vis_contents += muzzle_flash
	muzzle_flash.applied = TRUE

	addtimer(CALLBACK(src, PROC_REF(remove_muzzle_flash), flash_loc, muzzle_flash), 0.2 SECONDS)

/obj/item/gun/proc/reset_light_range(lightrange)
	set_light_range(lightrange)
	set_light_color(initial(light_color))
	if(lightrange <= 0)
		set_light_on(FALSE)
	update_light()

/obj/item/gun/proc/remove_muzzle_flash(atom/movable/flash_loc, obj/effect/muzzle_flash/muzzle_flash)
	if(!QDELETED(flash_loc))
		flash_loc.vis_contents -= muzzle_flash
	muzzle_flash.applied = FALSE

//I need to refactor this into an attachment
/datum/action/toggle_scope_zoom
	name = "Toggle Scope"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	var/obj/item/gun/gun = null

/datum/action/toggle_scope_zoom/Trigger()
	gun.zoom(owner, owner.dir)

/datum/action/toggle_scope_zoom/IsAvailable()
	. = ..()
	if(!. && gun)
		gun.zoom(owner, owner.dir, FALSE)

/datum/action/toggle_scope_zoom/Remove(mob/living/L)
	gun.zoom(L, L.dir, FALSE)
	..()

/obj/item/gun/proc/rotate(atom/thing, old_dir, new_dir)
	SIGNAL_HANDLER

	if(ismob(thing))
		var/mob/lad = thing
		lad.client.view_size.zoomOut(zoom_out_amt, zoom_amt, new_dir)

/obj/item/gun/proc/zoom(mob/living/user, direc, forced_zoom)
	if(!user || !user.client)
		return

	if(isnull(forced_zoom))
		if((!zoomed && wielded_fully) || zoomed)
			zoomed = !zoomed
		else
			to_chat(user, "<span class='danger'>You can't look down the scope without wielding [src]!</span>")
			zoomed = FALSE
	else
		zoomed = forced_zoom

	if(zoomed)
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(rotate))
		user.client.view_size.zoomOut(zoom_out_amt, zoom_amt, direc)
	else
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		user.client.view_size.zoomIn()
	return zoomed

//Proc, so that gun accessories/scopes/etc. can easily add zooming.
/obj/item/gun/proc/build_zooming()
	if(azoom)
		return

	if(zoomable)
		azoom = new()
		azoom.gun = src

/obj/item/gun/proc/build_firemodes()
	if(FIREMODE_FULLAUTO in gun_firemodes)
		AddComponent(/datum/component/automatic_fire, fire_delay)
		SEND_SIGNAL(src, COMSIG_GUN_DISABLE_AUTOFIRE)
	var/datum/action/item_action/our_action

	if(gun_firemodes.len > 1)
		our_action = new /datum/action/item_action/toggle_firemode(src)

	for(var/i=1, i <= gun_firemodes.len+1, i++)
		if(default_firemode == gun_firemodes[i])
			firemode_index = i
			if(gun_firemodes[i] == FIREMODE_FULLAUTO)
				SEND_SIGNAL(src, COMSIG_GUN_ENABLE_AUTOFIRE)
			if(our_action)
				our_action.UpdateButtonIcon()
			return

	firemode_index = 1
	CRASH("default_firemode isn't in the gun_firemodes list of [src.type]!! Defaulting to 1!!")

/obj/item/gun/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/toggle_firemode))
		fire_select(user)
	else
		..()

/obj/item/gun/unique_action(mob/living/user)
	if(bolt_type == BOLT_TYPE_NO_BOLT)
		chambered = null
		var/num_unloaded = 0
		for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
			CB.forceMove(drop_location())

			var/angle_of_movement =(rand(-3000, 3000) / 100) + dir2angle(turn(user.dir, 180))
			CB.AddComponent(/datum/component/movable_physics, _horizontal_velocity = rand(350, 450) / 100, _vertical_velocity = rand(400, 450) / 100, _horizontal_friction = rand(20, 24) / 100, _z_gravity = PHYSICS_GRAV_STANDARD, _z_floor = 0, _angle_of_movement = angle_of_movement, _bounce_sound = CB.bounce_sfx_override)

			num_unloaded++
			SSblackbox.record_feedback("tally", "station_mess_created", 1, CB.name)
		if (num_unloaded)
			to_chat(user, "<span class='notice'>You unload [num_unloaded] [cartridge_wording]\s from [src].</span>")
			playsound(user, eject_sound, eject_sound_volume, eject_sound_vary)
			update_appearance()
		else
			to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return
	if((bolt_type == BOLT_TYPE_LOCKING || bolt_type == BOLT_TYPE_CLIP) && bolt_locked)
		drop_bolt(user)
		return

	if (recent_rack > world.time)
		return
	recent_rack = world.time + rack_delay
	if(bolt_type == BOLT_TYPE_CLIP)
		rack(user, FALSE)
		update_appearance()
		return
	rack(user)
	update_appearance()
	return

/obj/item/gun/proc/fire_select(mob/living/carbon/human/user)

	//gun_firemodes = list(FIREMODE_SEMIAUTO, FIREMODE_BURST, FIREMODE_FULLAUTO, FIREMODE_OTHER)

	firemode_index++
	if(firemode_index > gun_firemodes.len)
		firemode_index = 1 //reset to the first index if it's over the limit. Byond arrays start at 1 instead of 0, hence why its set to 1.

	var/current_firemode = gun_firemodes[firemode_index]
	if(current_firemode == FIREMODE_FULLAUTO)
		SEND_SIGNAL(src, COMSIG_GUN_ENABLE_AUTOFIRE)
	else
		SEND_SIGNAL(src, COMSIG_GUN_DISABLE_AUTOFIRE)

	to_chat(user, span_notice("Switched to [gun_firenames[current_firemode]]."))
	playsound(user, 'sound/weapons/gun/general/selector.ogg', 100, TRUE)
	update_appearance()
	for(var/datum/action/current_action as anything in actions)
		current_action.UpdateButtonIcon()

/datum/action/item_action/toggle_firemode/UpdateButtonIcon(status_only = FALSE, force = FALSE)
	var/obj/item/gun/our_gun = target

	var/current_firemode = our_gun.gun_firemodes[our_gun.firemode_index]
	//tldr; if we have adjust_fire_select_icon_state_on_safety as true, we append "safety_" to the prefix, otherwise nothing.
	var/safety_prefix = "[our_gun.adjust_fire_select_icon_state_on_safety ? "[our_gun.safety ? "safety_" : ""]" : ""]"
	button_icon_state = "[safety_prefix][our_gun.fire_select_icon_state_prefix][current_firemode]"
	return ..()

/obj/item/gun/proc/reload(obj/item/new_mag, mob/living/user, params, force = FALSE)
	if(currently_firing_burst)
		return FALSE
	if(reciever_flags & AMMO_RECIEVER_CELL)
		if (!internal_magazine && istype(new_mag, /obj/item/stock_parts/cell/gun))
			var/obj/item/stock_parts/cell/new_cell = new_mag
			if (!installed_cell)
				insert_mag(user, new_cell)
			else
				if (tac_reloads)
					eject_mag(user, new_cell)
				else
					to_chat(user, span_notice("\The [src] already has a cell."))
	if(reciever_flags & AMMO_RECIEVER_MAGAZINES)
		if (!internal_magazine && istype(new_mag, /obj/item/ammo_box/magazine))
			var/obj/item/ammo_box/magazine/AM = new_mag
			if (!magazine)
				insert_mag(user, AM)
			else
				if (tac_reloads)
					eject_mag(user, FALSE, AM)
				else
					to_chat(user, span_notice("There's already a [magazine_wording] in \the [src]."))
			return TRUE
	if(reciever_flags & AMMO_RECIEVER_HANDFULS)
		if (istype(new_mag, /obj/item/ammo_casing) || istype(new_mag, /obj/item/ammo_box))
			if (bolt_type == BOLT_TYPE_NO_BOLT || internal_magazine)
				if (chambered && !chambered.BB)
					chambered.on_eject(shooter = user)
					chambered = null
				var/num_loaded = magazine.attackby(new_mag, user, params)
				if (num_loaded)
					to_chat(user, span_notice("You load [num_loaded] [cartridge_wording]\s into \the [src]."))
					playsound(src, load_sound, load_sound_volume, load_sound_vary)
					if (chambered == null && bolt_type == BOLT_TYPE_NO_BOLT)
						chamber_round()
					new_mag.update_appearance()
					update_appearance()
				return TRUE
	if(reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
		if (!internal_cell && istype(new_mag, /obj/item/stock_parts/cell/gun))
			var/obj/item/stock_parts/cell/gun/new_cell = new_mag
			if(!(new_cell.type in allowed_cell_types))
				return
			if(installed_cell)
				to_chat(user, span_warning("\The [new_mag] already has a cell"))
			insert_cell(user, new_cell)

///Handles all the logic needed for magazine insertion
/obj/item/gun/proc/insert_mag(mob/user, obj/item/ammo_box/magazine/inserted_mag, display_message = TRUE)
	if(gun_features_flags & GUN_ENERGY)
		if(!(inserted_mag.type in allowed_ammo_types))
			to_chat(user, span_warning("[inserted_mag] cannot fit into [src]!"))
			return FALSE
		if(user.transferItemToLoc(inserted_mag, src))
			installed_cell =inserted_mag
			to_chat(user, span_notice("You load the [inserted_mag] into \the [src]."))
			playsound(src, load_sound, load_sound_volume, load_sound_vary)
			update_appearance()
			return TRUE
		else
			to_chat(user, span_warning("You cannot seem to get \the [src] out of your hands!"))
			return FALSE
	else
		if(!istype(inserted_mag, default_ammo_type))
			to_chat(user, "<span class='warning'>\The [inserted_mag] doesn't seem to fit into \the [src]...</span>")
			return FALSE
		if(user.transferItemToLoc(inserted_mag, src))
			magazine = inserted_mag
			if (display_message)
				to_chat(user, "<span class='notice'>You load a new [magazine_wording] into \the [src].</span>")
			if (get_ammo_count(countchambered = FALSE))
				playsound(src, load_sound, load_sound_volume, load_sound_vary)
			else
				playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
			if (bolt_type == BOLT_TYPE_OPEN && !bolt_locked)
				chamber_round(TRUE)
			update_appearance()
			SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)
			return TRUE
		else
			to_chat(user, "<span class='warning'>You cannot seem to get \the [src] out of your hands!</span>")
			return FALSE

///Handles all the logic of magazine ejection, if tac_load is set that magazine will be tacloaded in the place of the old eject
/obj/item/gun/proc/eject_mag(mob/user, display_message = TRUE, obj/item/ammo_box/magazine/tac_load = null)
	if(gun_features_flags & GUN_ENERGY)
		playsound(src, load_sound, load_sound_volume, load_sound_vary)
		installed_cell.forceMove(drop_location())
		var/obj/item/stock_parts/cell/gun/old_cell = installed_cell
		old_cell.update_appearance()
		installed_cell = null
		to_chat(user, span_notice("You pull the cell out of \the [src]."))
		update_appearance()
		if(tac_load && tac_reloads)
			if(do_after(user, tactical_reload_delay, src, hidden = TRUE))
				if(insert_mag(user, tac_load))
					to_chat(user, span_notice("You perform a tactical reload on \the [src]."))
				else
					to_chat(user, span_warning("You dropped the old cell, but the new one doesn't fit. How embarassing."))
			else
				to_chat(user, span_warning("Your reload was interupted!"))
				return

		user.put_in_hands(old_cell)
		update_appearance()
	else
		if(bolt_type == BOLT_TYPE_OPEN)
			chambered = null
		if (get_ammo_count(countchambered = FALSE))
			playsound(src, eject_sound, eject_sound_volume, eject_sound_vary)
		else
			playsound(src, eject_empty_sound, eject_sound_volume, eject_sound_vary)
		magazine.forceMove(drop_location())
		var/obj/item/ammo_box/magazine/old_mag = magazine
		old_mag.update_appearance()
		magazine = null
		if (display_message)
			to_chat(user, "<span class='notice'>You pull the [magazine_wording] out of \the [src].</span>")
		update_appearance()
		SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)
		if (tac_load)
			if(do_after(user, tactical_reload_delay, src, hidden = TRUE))
				if (insert_mag(user, tac_load, FALSE))
					to_chat(user, "<span class='notice'>You perform a tactical reload on \the [src].</span>")
				else
					to_chat(user, "<span class='warning'>You dropped the old [magazine_wording], but the new one doesn't fit. How embarassing.</span>")
			else
				to_chat(user, "<span class='warning'>Your reload was interupted!</span>")
				return
		if(user)
			user.put_in_hands(old_mag)
		update_appearance()
		SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)
	return

/obj/item/gun/proc/insert_cell(mob/user, obj/item/stock_parts/cell/gun/C)
	if(user.transferItemToLoc(C, src))
		installed_cell = C
		to_chat(user, span_notice("You load the [C] into \the [src]."))
		playsound(src, load_sound, load_sound_volume, load_sound_vary)
		update_appearance()
		return TRUE
	else
		to_chat(user, span_warning("You cannot seem to get \the [src] out of your hands!"))
		return FALSE

/obj/item/gun/proc/eject_cell(mob/user, obj/item/stock_parts/cell/gun/tac_load = null)
	if(reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
		playsound(src, load_sound, load_sound_volume, load_sound_vary)
		installed_cell.forceMove(drop_location())
		var/obj/item/stock_parts/cell/gun/old_cell = installed_cell
		installed_cell = null
		user.put_in_hands(old_cell)
		old_cell.update_appearance()
		to_chat(user, span_notice("You pull the cell out of \the [src]."))
		update_appearance()

/obj/item/gun/proc/adjust_current_rounds(obj/item/mag, new_rounds)
	return

/obj/item/gun/proc/get_ammo_count(countchambered = TRUE)
	return

/obj/item/gun/proc/get_max_ammo(countchamber = TRUE)
	return

/obj/item/gun/proc/get_ammo_list(countchambered = TRUE, drop_all = FALSE)
	return

/obj/item/gun/proc/get_rounds_per_shot()
	return 1

/obj/item/gun/proc/get_charge_ratio()
	if(reciever_flags & AMMO_RECIEVER_SECONDARY_CELL)
		if(!installed_cell)
			return FALSE
		return CEILING(clamp(installed_cell.charge / installed_cell.maxcharge, 0, 1) * charge_sections, 1)// Sets the ratio to 0 if the gun doesn't have enough charge to fire, or if its power cell is removed.

/obj/item/gun/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, selfcharge))
			if(var_value)
				START_PROCESSING(SSobj, src)
			else
				STOP_PROCESSING(SSobj, src)
	. = ..()

GLOBAL_LIST_INIT(gun_saw_types, typecacheof(list(
	/obj/item/gun/energy/plasmacutter,
	/obj/item/melee/transforming/energy,
	)))

///Handles all the logic of sawing off guns,
/obj/item/gun/proc/try_sawoff(mob/user, obj/item/saw)
	if(!saw.get_sharpness() || !is_type_in_typecache(saw, GLOB.gun_saw_types) && saw.tool_behaviour != TOOL_SAW) //needs to be sharp. Otherwise turned off eswords can cut this.
		return
	if(sawn_off)
		to_chat(user, span_warning("\The [src] is already shortened!"))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_notice("[user] begins to shorten \the [src]."), span_notice("You begin to shorten \the [src]..."))

	//if there's any live ammo inside the gun, makes it go off
	if(blow_up(user))
		user.visible_message(span_danger("\The [src] goes off!"), span_danger("\The [src] goes off in your face!"))
		return

	if(do_after(user, 30, target = src))
		user.visible_message(span_notice("[user] shortens \the [src]!"), span_notice("You shorten \the [src]."))
		sawoff(user, saw)


/obj/item/gun/proc/sawoff(forced = FALSE)
	if(sawn_off && !forced)
		return
	name = "sawn-off [src.name]"
	desc = sawn_desc
	w_class = WEIGHT_CLASS_NORMAL
	item_state = "gun"
	slot_flags &= ~ITEM_SLOT_BACK	//you can't sling it on your back
	slot_flags |= ITEM_SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
	recoil = SAWN_OFF_RECOIL
	sawn_off = TRUE
	update_appearance()
	return TRUE

///used for sawing guns, causes the gun to fire without the input of the user
/obj/item/gun/proc/blow_up(mob/user)
	return

/obj/item/gun/get_cell()
	return installed_cell

/obj/item/gun/screwdriver_act(mob/living/user, obj/item/I)
	if((reciever_flags & AMMO_RECIEVER_CELL | reciever_flags & AMMO_RECIEVER_SECONDARY_CELL) && installed_cell && !internal_magazine)
		to_chat(user, span_notice("You begin unscrewing and pulling out the cell..."))
		if(I.use_tool(src, user, unscrewing_time, volume = 100))
			to_chat(user, span_notice("You remove the power cell."))
			if(reciever_flags & AMMO_RECIEVER_CELL)
				eject_mag(user)
			else
				eject_cell(user)

