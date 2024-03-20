extends "res://global/longmenu.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#spawn standard-number-of-moves plus one for back option items
	for n in range(0,5):
		instance_item("aa\naa")
		actives.append( items[n] )
	items[4].setlabel("back")
	place_items(yd)
	sizer()
	update_cursor()

func mupdate(slot = 0):
	actives.clear()
	for n in range(0,4):
		var move = btlhead.slots[slot].mon.getmove(n)
		#check if move is valid/real... for now just check is slot is empty idk
		#
		if d.moves.move_isvalid(move):
			var movedata = d.moves.move_getmove(move)
			#where load move data? global autoload data.move, data.species?...
			items[n].activate( true, movedata[dt.tgname] )#g.lmoves.move_getname(move) + '\n' + str(btlhead.slots[slot].mon.usepoints[n]) + '/' + str(btlhead.slots[slot].mon.usemaxs[n]))
			#will also have type, PP
			actives.append(items[n])
			
			items[n].clear_data()
			items[n].add_data("moveid", move)
			items[n].add_data("moveindex", n)
		else:
			items[n].activate()#deactivates lol
	#then add back button
	actives.append(items[4])

#update_cursor is defined in lomgmenu (:

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func execute_cursor(slot = 0, target = 1):
	#since moveid and moveindex are stored in optbase, full item index isn't needed.
	#so just get deytah from actives[cursor].get_data()
	if cursor == actives.size()-1:# back with yee
		btlhead.restate(btlhead.OPTIONS)
	else:
		btlhead.slots[slot].set_movenext(
			actives[cursor].get_data("moveid"),
			actives[cursor].get_data("moveindex"),
			target
			)
	
	#finally...
	#btlhead.restate(btlhead.EXECTURN)
		btlhead.exec_turn()
