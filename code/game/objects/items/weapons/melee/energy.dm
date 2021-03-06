/obj/item/weapon/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	var/mod_handy_a
	var/mod_weight_a
	var/mod_reach_a
	sharp = 0
	edge = 0
	armor_penetration = 50
	atom_flags = ATOM_FLAG_NO_BLOOD

/obj/item/weapon/melee/energy/proc/activate(mob/living/user)
	anchored = 1
	if(active)
		return
	active = 1
	force = active_force
	throwforce = active_throwforce
	sharp = 0
	edge = 1
	slot_flags |= SLOT_DENYPOCKET
	mod_handy = mod_handy_a
	mod_weight = mod_weight_a
	mod_reach = mod_reach_a
	playsound(user, 'sound/weapons/saberon.ogg', 50, 1)

/obj/item/weapon/melee/energy/proc/deactivate(mob/living/user)
	anchored = 0
	if(!active)
		return
	playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
	active = 0
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	slot_flags = initial(slot_flags)
	mod_handy = initial(mod_handy)
	mod_weight = initial(mod_weight)
	mod_reach = initial(mod_reach)

/obj/item/weapon/melee/energy/attack_self(mob/living/user as mob)
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts \himself with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/weapon/melee/energy/get_storage_cost()
	if(active)
		return ITEM_SIZE_NO_CONTAINER
	return ..()

/*
 * Energy Axe
 */
/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	//active_force = 150 //holy...
	active_force = 60
	active_throwforce = 45
	//force = 40
	//throwforce = 25
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	mod_weight = 1.5
	mod_reach = 1.25
	mod_handy = 1.5
	mod_weight_a = 1.5
	mod_reach_a = 1.25
	mod_handy_a = 1.5
	atom_flags = ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1

/obj/item/weapon/melee/energy/axe/activate(mob/living/user)
	..()
	icon_state = "axe1"
	to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

/obj/item/weapon/melee/energy/axe/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, "<span class='notice'>\The [src] is de-energised. It's just a regular axe now.</span>")

/*
 * Energy Sword
 */
/obj/item/weapon/melee/energy/sword
	color
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	active_force = 45
	active_throwforce = 45
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 10
	w_class = ITEM_SIZE_SMALL
	mod_weight = 0.5
	mod_reach = 0.3
	mod_handy = 1.0
	mod_weight_a = 1.25
	mod_reach_a = 1.5
	mod_handy_a = 1.5
	atom_flags = ATOM_FLAG_NO_BLOOD
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	sharp = 0
	edge = 1
	var/blade_color

/obj/item/weapon/melee/energy/sword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		spawn(20)
		deactivate(user)

/obj/item/weapon/melee/energy/sword/New()
	blade_color = pick("red","blue","green","purple")

/obj/item/weapon/melee/energy/sword/green/New()
	blade_color = "green"

/obj/item/weapon/melee/energy/sword/red/New()
	blade_color = "red"

/obj/item/weapon/melee/energy/sword/blue/New()
	blade_color = "blue"

/obj/item/weapon/melee/energy/sword/purple/New()
	blade_color = "purple"

/obj/item/weapon/melee/energy/sword/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
		mod_shield = 2.5
	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	icon_state = "sword[blade_color]"

/obj/item/weapon/melee/energy/sword/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
		mod_shield = 1.0
	..()
	attack_verb = list()
	icon_state = initial(icon_state)

/obj/item/weapon/melee/energy/sword/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (istype(W,/obj/item/weapon/melee/energy/sword))
		to_chat(user, "<span class='notice'>You attach the ends of the two energy swords, making a single double-bladed weapon!</span>")
		new /obj/item/weapon/melee/energy/dualsaber(user.loc)
		qdel(W)
		W = null
		qdel(src)

/obj/item/weapon/melee/energy/sword/handle_shield(mob/user)
	. = ..()

	if(.)
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/obj/item/weapon/melee/energy/sword/pirate/activate(mob/living/user)
	..()
	icon_state = "cutlass1"


/obj/item/weapon/melee/energy/sword/bogsword
	name = "alien sword"
	desc = "A strange, strange energy sword."
	icon_state = "sword0"

/obj/item/weapon/melee/energy/sword/bogswrd/activate(mob/living/user)
	..()
	icon_state = "bog_sword"

/*
 *DualSaber
 */


/obj/item/weapon/melee/energy/dualsaber
	color
	name = "dualsaber"
	desc = "May the Dark side be within you."
	icon_state = "dualsaber0"
	active_force = 70
	active_throwforce = 70
	force = 5
	throwforce = 10
	throw_speed = 1
	throw_range = 10
	w_class = ITEM_SIZE_SMALL
	mod_weight = 0.5
	mod_reach = 0.4
	mod_handy = 1.0
	mod_weight_a = 1.5
	mod_reach_a = 1.5
	mod_handy_a = 1.75
	atom_flags = ATOM_FLAG_NO_BLOOD
	origin_tech = list(TECH_MAGNET = 4, TECH_ILLEGAL = 5)
	sharp = 0
	edge = 1
	var/blade_color
	var/base_block_chance = 50

/obj/item/weapon/melee/energy/dualsaber/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		spawn(20)
		deactivate(user)

/obj/item/weapon/melee/energy/dualsaber/New()
	blade_color = pick("red","blue","green","purple")

/obj/item/weapon/melee/energy/dualsaber/green/New()
	blade_color = "green"

/obj/item/weapon/melee/energy/dualsaber/red/New()
	blade_color = "red"

/obj/item/weapon/melee/energy/dualsaber/blue/New()
	blade_color = "blue"

/obj/item/weapon/melee/energy/dualsaber/purple/New()
	blade_color = "purple"

/obj/item/weapon/melee/energy/dualsaber/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
		mod_shield = 2.5
	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	icon_state = "dualsaber[blade_color]"

/obj/item/weapon/melee/energy/dualsaber/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
		mod_shield = 1.0
	..()
	attack_verb = list()
	icon_state = initial(icon_state)

/obj/item/weapon/melee/energy/dualsaber/handle_shield(mob/user)
	. = ..()

	if(.)
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/*
 *Energy Blade
 */

//Can't be activated or deactivated, so no reason to be a subtype of energy
/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	armor_penetration = 100
	sharp = 1
	edge = 1
	anchored = 1    // Never spawned outside of inventory, should be fine.
	throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEM_SIZE_TINY //technically it's just energy or something, I dunno
	mod_weight = 1.0
	mod_reach = 1.5
	mod_handy = 1.75
	mod_weight_a = 1.25
	mod_reach_a = 1.5
	mod_handy_a = 1.75
	atom_flags = ATOM_FLAG_NO_BLOOD
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/item/weapon/melee/energy/blade/New()
	..()
	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/weapon/melee/energy/blade/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/melee/energy/blade/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/melee/energy/blade/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/weapon/melee/energy/blade/attack_self(mob/user as mob)
	user.drop_from_inventory(src)
	spawn(1) if(src) qdel(src)

/obj/item/weapon/melee/energy/blade/dropped()
	..()
	spawn(1) if(src) qdel(src)

/obj/item/weapon/melee/energy/blade/Process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		spawn(1) if(src) qdel(src)

/obj/item/weapon/melee/energy/blade/handle_shield(mob/user) // C'mon it's an esword on crack why would it be unable to reflect projectiles?
	. = ..()

	if(.)
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
