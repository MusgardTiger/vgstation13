var/list/prob_G_list = list()

/proc/probG(var/define,var/everyother)
	writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/proc/probG() called tick#: [world.time]")
	if(prob_G_list["[define]"])
		prob_G_list["[define]"] += 1
		if(prob_G_list["[define]"] == everyother)
			prob_G_list["[define]"] = 0
			return 1
	else
		(prob_G_list["[define]"]) = 0
		(prob_G_list["[define]"]) = rand(1,everyother-1)
	return 0
