extends "res://global/2columnmenu.gd"

const baseopts = ["Battle","Party","Bag","Run"]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for n in range(0,4):
		instance_item(baseopts[n])
		#actives.append( items[n] )
	place_items(xd,yd+8)
	active_all()
	sizer()
	update_cursor()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func execute_cursor():
	match cursor:
		0:
			btlhead.restate(btlhead.MOVES)
		1:
			btlhead.restate(btlhead.PARTYM)#party
		2:
			pass#bag...
		3:
			pass#run (:
			#rather, set active mon's next move to run
			btlhead.slots[0].set_movenext( "run",0,0 )
			btlhead.exec_turn()
