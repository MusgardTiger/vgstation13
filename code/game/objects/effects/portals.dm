/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 5
	var/obj/item/target = null
	var/creator = null
	anchored = 1.0
	w_type=NOT_RECYCLABLE

/obj/effect/portal/Bumped(mob/M as mob|obj)
	spawn(0)
		src.teleport(M)
		return
	return

/obj/effect/portal/Crossed(AM as mob|obj)
	spawn(0)
		src.teleport(AM)
		return
	return

/obj/effect/portal/New()
	..()
	spawn(300)
		qdel(src)
		return
	return

/obj/effect/portal/proc/teleport(atom/movable/M as mob|obj)
	writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/obj/effect/portal/proc/teleport() called tick#: [world.time]")
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (M.anchored&&istype(M, /obj/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		del(src)
		return
	if (istype(M, /atom/movable))
		var/area/A = get_area(target)
		if(A && A.anti_ethereal)
			visible_message("<span class='sinister'>A dark form vaguely ressembling a hand reaches through the portal and tears it apart before anything can go through.</span>")
			del(src)
		else
			if(prob(failchance)) //oh dear a problem, put em in deep space
				src.icon_state = "portal1"
				do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
			else
				do_teleport(M, target, 1) ///You will appear adjacent to the beacon

