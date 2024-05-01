extends "res://global/2columnmenu.gd"

signal faint_switch_done
var forced_switch = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in range(0,7):#party max size + 1
		instance_item("AAA")
		#actives.append( items[n] )
		items[n].add_data("index", n)
	items[-1].setlabel("Back")
	place_items(5,8,15)
	active_all()
	sizer()
	update_cursor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func pupdate(force = false):
	#since this is called "blindly" from restate, force mode can be just passed in, unless another
	#state is added.
	#heck, just add a state
	forced_switch = force
	actives.clear()
	
	var slot = btlhead.current_cursor

	var temp = btlhead.slots[slot].mon.temp
	#print(temp)
	for m in range(0,6):#party max size not plus 1
		if m < party.party.size():
			if m == temp or not btlhead.check_mon(party.party[m]):
				pass#.activate(false,name)
				items[m].activate(false, party.party[m].nname)
			else:
				actives.append( items[m] )
				items[m].activate(true,party.party[m].nname)
		else:
			pass#.activate no name
			items[m].activate()
	
	#if not force-switch mode/faint-switch
	if not forced_switch:
		actives.append(items[-1])#le back
		items[-1].activate(true,"Back")
	else:
		items[-1].activate(false,"Back")
	activescount = actives.size()
	update_cursor()

#slot can be removed
func execute_cursor(_slot = 0):
	var slot = btlhead.current_cursor
	#and if not force-switch
	if cursor == actives.size() -1 and not forced_switch:
		btlhead.restate(btlhead.OPTIONS)
	else:
		btlhead.slots[slot].set_movenext(
			"switch",
			actives[cursor].get_data("index"),#idk this isn't really used anyway
			actives[cursor].get_data("index")#target
		)
		
		#emit signal- if not forced-switch it should just get ignored which is fine
		if forced_switch:
			emit_signal("faint_switch_done")
		#if done with all mons on your side...
		else:#this should be fine
			#btlhead.exec_turn()
			btlhead.restate(btlhead.NEXTOREXEC)
			#next: return to btlhead to determine next step
	
