extends "res://global/menubase.gd"
class_name longmenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#should contain the logic for laying out items in a single column
func place_items(yplus = 0):
	
	#var xxx = items[0].xdel + xplus
	var yy = items[0].ydel + yplus
	#var yyy = yy
	#if yy == -1:#use default yd from menubase... or optbase
		##i don't know why this doesn't seem to be working
		#yyy = yd
	
	var n = 0
	for it in items:
		it.position = Vector2(0,yy*n)
		n += 1
	
	print( items[-1].position )

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

#some of this, namely instantiating items, can be moved to menubase,
#and then shared with create_empty_menu
#but item-placing code is of course different per menu type
func create_menu(num,list):
	
	base_create_menu(num,list)
	#await?
	place_items(0)#does this even need doing
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
