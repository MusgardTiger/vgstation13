
//Apprenticeship contract - moved to antag_spawner.dm

///////////////////////////Veil Render//////////////////////

/obj/item/weapon/veilrender
	name = "veil render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast city."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	item_state = "render"
	force = 15
	throwforce = 10
	w_class = W_CLASS_MEDIUM
	var/charged = 1
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/effect/rend
	name = "tear in the fabric of reality"
	desc = "You should run now"
	icon = 'icons/obj/biomass.dmi'
	icon_state = "rift"
	density = 1
	anchored = 1.0

/obj/effect/rend/New()
	spawn(50)
		new /obj/machinery/singularity/narsie/wizard(get_turf(src))
		qdel(src)
		return
	return

/obj/item/weapon/veilrender/attack_self(mob/user as mob)
	if(charged == 1)
		new /obj/effect/rend(get_turf(usr))
		charged = 0
		visible_message("<span class='danger'>[src] hums with power as [usr] deals a blow to reality itself!</span>")
	else
		to_chat(user, "<span class='warning'>The unearthly energies that powered the blade are now dormant.</span>")



/obj/item/weapon/veilrender/vealrender
	name = "veal render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast farm."

/obj/item/weapon/veilrender/vealrender/attack_self(mob/user as mob)
	if(charged)
		new /obj/effect/rend/cow(get_turf(usr))
		charged = 0
		visible_message("<span class='danger'>[src] hums with power as [usr] deals a blow to hunger itself!</span>")
	else
		to_chat(user, "<span class='warning'>The unearthly energies that powered the blade are now dormant.</span>")

/obj/effect/rend/cow
	desc = "Reverberates with the sound of ten thousand moos."
	var/cowsleft = 20

/obj/effect/rend/cow/New()
	processing_objects.Add(src)
	return

/obj/effect/rend/cow/process()
	if(locate(/mob) in loc)
		return
	new /mob/living/simple_animal/cow(loc)
	cowsleft--
	if(cowsleft <= 0)
		qdel (src)

/obj/effect/rend/cow/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/nullrod))
		visible_message("<span class='danger'>[I] strikes a blow against \the [src], banishing it!</span>")
		spawn(1)
			qdel (src)
		return
	..()


/////////////////////////////////////////Scrying///////////////////

/obj/item/weapon/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state ="bluespace"
	throw_speed = 7
	throw_range = 15
	throwforce = 15
	damtype = BURN
	force = 15
	hitsound = 'sound/items/welder2.ogg'

/obj/item/weapon/scrying/attack_self(mob/user as mob)
	to_chat(user, "<span class='notice'>You can see...everything!</span>")
	visible_message("<span class='danger'>[usr] stares into [src], their eyes glazing over.</span>")
	user.ghostize(1)
	user.mind.isScrying = 1
	return


//necromancy moved to code\modules\projectiles\guns\energy\special.dm --Sonix


#define CLOAKINGCLOAK "cloakingcloak"

/obj/item/weapon/cloakingcloak
	name = "cloak of cloaking"
	desc = "A silk cloak that will hide you from anything with eyes."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "cloakingcloak"
	w_class = W_CLASS_MEDIUM
	force = 0
	flags = FPRINT | TWOHANDABLE
	var/event_key

/obj/item/weapon/cloakingcloak/proc/mob_moved(var/list/event_args, var/mob/holder)
	if(iscarbon(holder) && wielded)
		var/mob/living/carbon/C = holder
		if(C.m_intent == "run" && prob(10))
			if(C.Slip(4, 5))
				step(C, C.dir)
				C.visible_message("<span class='warning'>\The [C] trips over \his [name] and appears out of thin air!</span>","<span class='warning'>You trip over your [name] and become visible again!</span>")

/obj/item/weapon/cloakingcloak/update_wield(mob/user)
	..()
	if(user)
		user.update_inv_hands()
		if(wielded)
			user.visible_message("<span class='danger'>\The [user] throws \the [src] over \himself and disappears!</span>","<span class='notice'>You throw \the [src] over yourself and disappear.</span>")
			event_key = user.on_moved.Add(src, "mob_moved")
			user.alpha = 1	//to cloak immediately instead of on the next Life() tick
			user.alphas[CLOAKINGCLOAK] = 1
		else
			user.visible_message("<span class='warning'>\The [user] appears out of thin air!</span>","<span class='notice'>You take \the [src] off and become visible again.</span>")
			user.on_moved.Remove(event_key)
			event_key = null
			user.alpha = initial(user.alpha)
			user.alphas.Remove(CLOAKINGCLOAK)


/obj/item/weapon/glow_orb
	name = "inert stone"
	desc = "A peculiar fist-sized stone which hums with dormant energy."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "glow_stone_dormant"
	w_class = W_CLASS_TINY
	force = 0
	var/prime_time = 2 SECONDS
	var/crit_failure = 0
	var/activating = 0

/obj/item/weapon/glow_orb/attack_self(mob/user)
	if(crit_failure)
		to_chat(user, "<span class = 'warning'>\The [src] is vibrating erratically!</span>")
		return
	if(activating)
		to_chat(user, "<span class = 'warning'>\The [src] hums with energy as it begins to glow brighter.</span>")
		return
	if(iswizard(user) || isapprentice(user))
		to_chat(user, "<span class = 'notice'>You prime the glow-stone, it will transform in [prime_time/10] seconds.</span>")
		activate()
		return
	else
		if (clumsy_check(user) && prob(50))
			to_chat(user, "<span class = 'notice'>Ooh, shiny!</span>")
			failure()
			return
		else if(prob(65))
			to_chat(user, "<span class = 'notice'>You find what appears to be an on button, and press it.</span>")
			activate()
		else
			if(prob(5))
				visible_message("<span class = 'warning'>\The [src] ticks [pick("ominously","forebodingly", "harshly")].</span>")
				if(prob(50))
					failure()
			to_chat(user, "<span class = 'notice'>You fiddle with \the [src], but find nothing of interest.</span>")

/obj/item/weapon/glow_orb/proc/activate()
	activating = 1
	spawn(prime_time)
		if(crit_failure) //Damn it clown
			return
		if(ismob(loc))
			var/mob/M = loc
			M.drop_from_inventory(src)
		playsound(src, 'sound/weapons/orb_activate.ogg', 50,1)
		flick("glow_stone_activate", src)
		spawn(10)
			new/mob/living/simple_animal/hostile/glow_orb(get_turf(src))
			qdel(src)

/obj/item/weapon/glow_orb/proc/failure()
	visible_message("<span class = 'notice'>\The [src] begins to glow increasingly in a brilliant manner...</span>")
	crit_failure = 1
	spawn(1 SECONDS)
		visible_message("<span class = 'warning>...and vibrate violently!</span>")
	playsound(src,'sound/weapons/inc_tone.ogg', 50, 1)
	spawn(2 SECONDS)
		explosion(loc, 0, 1, 2, 3)
		qdel(src)