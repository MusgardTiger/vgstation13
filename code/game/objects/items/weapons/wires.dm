// WIRES

/obj/item/weapon/wire/proc/update()
	writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/obj/item/weapon/wire/proc/update() called tick#: [world.time]")
	if (src.amount > 1)
		src.icon_state = "spool_wire"
		src.desc = text("This is just spool of regular insulated wire. It consists of about [] unit\s of wire.", src.amount)
	else
		src.icon_state = "item_wire"
		src.desc = "This is just a simple piece of regular insulated wire."
	return

/obj/item/weapon/wire/attack_self(mob/user as mob)
	if (src.laying)
		src.laying = 0
		user << "<span class='notice'>You're done laying wire!</span>"
	else
		user << "<span class='notice'>You are not using this to lay wire...</span>"
	return


