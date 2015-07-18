/client/proc/atmosscan()
	set category = "Mapping"
	set name = "Check Plumbing"
	writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/client/proc/atmosscan() called tick#: [world.time]")
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	feedback_add_details("admin_verb","CP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	//all plumbing - yes, some things might get stated twice, doesn't matter.
	for (var/obj/machinery/atmospherics/plumbing in atmos_machines)
		if (plumbing.nodealert)
			usr << "Unconnected [plumbing.name] located at [formatJumpTo(plumbing.loc)]"

	//Manifolds
	for (var/obj/machinery/atmospherics/pipe/manifold/pipe in atmos_machines)
		if (!pipe.node1 || !pipe.node2 || !pipe.node3)
			usr << "Unconnected [pipe.name] located at [formatJumpTo(pipe.loc)]"

	//4-way Manifolds
	for (var/obj/machinery/atmospherics/pipe/manifold4w/pipe in atmos_machines)
		if (!pipe.node1 || !pipe.node2 || !pipe.node3 || !pipe.node4)
			usr << "Unconnected [pipe.name] located at [formatJumpTo(pipe.loc)]"

	//Pipes
	for (var/obj/machinery/atmospherics/pipe/simple/pipe in atmos_machines)
		if (!pipe.node1 || !pipe.node2)
			usr << "Unconnected [pipe.name] located at [formatJumpTo(pipe.loc)]"

/client/proc/powerdebug()
	set category = "Mapping"
	set name = "Check Power"
	writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/client/proc/powerdebug() called tick#: [world.time]")
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	feedback_add_details("admin_verb","CPOW") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	for (var/datum/powernet/PN in powernets)
		if (!PN.nodes || !PN.nodes.len)
			if(PN.cables && (PN.cables.len > 1))
				var/obj/structure/cable/C = PN.cables[1]
				usr << "Powernet with no nodes! (number [PN.number]) - example cable at [C.x], [C.y], [C.z] in area [get_area(C.loc)]"

		if (!PN.cables || (PN.cables.len < 10))
			if(PN.cables && (PN.cables.len > 1))
				var/obj/structure/cable/C = PN.cables[1]
				usr << "Powernet with fewer than 10 cables! (number [PN.number]) - example cable at [C.x], [C.y], [C.z] in area [get_area(C.loc)]"