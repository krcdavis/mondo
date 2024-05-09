extends Monster
class_name dfmonster
#default project example monster extension class


#fake example added stat

var qxst: int
var gxst: int
var xstat: int

func setstats(helth = -1):
	#set xstat, then pass to base setstats
	print("custom set stats")
	xstat = setstat(d.sph.getstg(species_id, d.species.xstat))
	super.setstats(helth)#it werks


#unique exp system goes here
func add_exp(amt):
	var newexpr = expr + amt
	#get level from exp. if level > level, ...
	var newlevel = get_level_from_exp(newexpr)
	if newlevel > level:
		update_level(newlevel)
	expr = newexpr
	
	#just put this here for now
	gb.currenttext.textplay(str("%s grew to level %s!" % [nname, str(level)]))
	await gb.currenttext.textover
	emit_signal("leveldone")

#very simply 100 exp per level
func get_exp_for_level(l):
	return (l-1)*100
#ditto
func get_level_from_exp(exp):
	return int((exp/100)) +1
