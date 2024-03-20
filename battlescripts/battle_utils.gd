extends "battle_basis.gd"

#lol
func speedTie(mona, monb):
	if mona.cspd != monb.cspd:
		return mona.cspd > monb.cspd
	else: #speedtie
		return gb.rng.randi() < gb.rng.randi()#lmao


func cleanup_fainted():
	pass
	#take note of fainted mons on field and act accordingly
	#this is literally just the wild one-on-one version only

func hidelabels():
	for l in labels:
		l.visible = false

func showlabels():
	for l in labels:
		l.visible = true

func update_label(slot):
	labels[slot].sethp(slots[slot].mon.hp,slots[slot].mon.health)

func loadmon_model(slot):
	#slots...
	var string = d.get_datapath()  + "montscns/" + d.sph.getstg(slots[slot].mon.species_id, dt.tgmodel) + ".tscn"
	var temp# = load(d.get_datapath()  + "montscns/" + d.species.getstg(slots[slot].mon.species_id, dt.tgmodel) + ".tscn")#lol
	#lololol
	if FileAccess.file_exists(string):
		temp = load(string)
	else:
		temp = load("res://cyoob.tscn")
		print(string)
	var temp2 = temp.instantiate()
	temp2.name = "model"#yes, still necessary
	points[slot].add_child(temp2)
	

func faintmon(slot):
	$battlehud/textbox.textplay(str("%s is out of the battle!" % slots[slot].mon.nname))
	await $battlehud/textbox.textover
	removemon(slot)
	emit_signal("thingdone")


func removemon(slot):
	#could just get points[slot].get_node() ...
	var lol = get_node_or_null("point"+str(slot)+"/model")
	if lol:
		get_node_or_null("point"+str(slot)+"/model").name = "delet"
		get_node_or_null("point"+str(slot)+"/delet").queue_free()
	

#used in above and in eg loading party for swap menu
func check_mon(mon, temp = -1):
	#check if mom can be sent out
	#return false if empty slot, fainted, if temp matched (will not match -1 obvs)
	if !mon: return false #if null
	if mon.health <= 0: return false
	if mon.temp == temp: return false#does 'in' work for single values?
	#isn't implemented yet, but if some flag for empty slot is matched, eg species == -1, return false
	#muh nandummy
	#if you made it this far you're lino
	return true

func swap_mon(slot, mon):
	#unload current mon's model
	removemon(slot)
	#and load new
	slots[slot].mon = mon
	slots[slot].load_into_battle()
	
	loadmon_model(slot)
	$battlehud/textbox.textplay(str("Go, %s!" % slots[slot].mon.nname))
	await $battlehud/textbox.textover
	
	labels[slot].settext(slots[slot].mon.nname)
	labels[slot].sethp(slots[slot].mon.hp,slots[slot].mon.health)
	
	emit_signal("thingdone")

func check_party(temp = -1):#start = 0 ?...
	for mon in party.party: #will eventually be a set of 4/6 with empty slots which need to be falsed; for now just faint status
		#check_mon(mon)
		if check_mon(mon, temp): return mon#rets first available mon for starting battle
	return null



func try_running():
	pass
	#lol run lol
	$battlehud/textbox.textplay("You bravely ran away!!")
	await $battlehud/textbox.textover
	cleanup()
	emit_signal("thingdone")

func win():
	#for now, award one level to the mon currently out (in slot 0)
	print('win')
	#slots[0].mon.addlevel()
	#$battlehud/textbox.textplay(str("%s gained a level for securing the win!" % slots[0].mon.nname))
	#await $battlehud/textbox.textover
	$battlehud/textbox.textplay("you've winned!!")
	await $battlehud/textbox.textover
	cleanup()
	#emit_signal("thingdone")

func wipeout():
	$battlehud/textbox.textplay("You've lost your last useable Monstar...")
	await $battlehud/textbox.textover
	$battlehud/textbox.textplay("... you wiped out!!")
	await $battlehud/textbox.textover
	#emit_signal("thingdone")#before or after?
	#head.wipeout()#should work now
	cleanup()

func cleanup():
	#clean up battlefield for ending battle
	for slot in slots.size(): removemon(slot)
	self.visible = false
	mode = "no"
	for l in labels: l.visible = false
	#clear slots?
	head.deactivate_battle()
	returncam.make_current()


# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#pass
