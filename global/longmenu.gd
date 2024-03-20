extends "res://global/menubase.gd"
class_name longmenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#should contain the logic for laying out items in a single column
func place_items(yy = -1):
	var yyy = yy
	if yy == -1:#use default yd from menubase... or optbase
		#i don't know why this doesn't seem to be working
		yyy = yd
	
	var n = 0
	for it in items:
		it.position += Vector2(0,yy*n)
		n += 1
	
	print( items[-1].position )

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func create_menu(num,list):
	
	for n in range(0,num):
		instance_item(list[n])
		#items[n].setlabel(list[n])
		#optbase's own ready function calls setlabel after instancing... sometimes... seemingly fixed
		items[n].add_data("index", n)
		items[n].add_data("data", list[n])
	
	active_all()
	place_items(yd)
	sizer()
	update_cursor()
	
	

#tall menu
#up and right +1, down and left -1
func update_cursor(val = "Z"):#passes in "UP,"DW","LF","RT"
	var v = 0
	match val:
		"UP","LF":
			v = -1
		"DW","RT":
			v = 1
	cursor = (cursor + v + actives.size()) % actives.size()
	for n in range(0,actives.size()):
		actives[n].highlight(n == cursor)
