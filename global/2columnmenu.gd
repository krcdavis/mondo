extends "res://global/menubase.gd"
class_name twocolumnenu


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#now change to use optbase's set xdel and ydel pls.
func place_items(xplus=0,yplus=0,oddset=0):
	#you should have at least one item by now so just use items[0].xdel
	if items.size() == 0: return
	
	var xxx = items[0].xdel + xplus
	var yy = items[0].ydel + yplus
	
	var n = 0
	for it in items:
		#for y, add oddset*(n%1)
		#is this plus or equal?
		@warning_ignore("integer_division")
		it.position = Vector2(xxx*(n%2),yy*int(n/2) + oddset*(n%2))
		n += 1

func create_menu(num,list):
	
	for n in range(0,num):
		instance_item(list[n])
		#items[n].setlabel(list[n])
		#optbase's own ready function calls setlabel after instancing... sometimes... seemingly fixed
		items[n].add_data("index", n)
		items[n].add_data("data", list[n])
	
	active_all()
	place_items(0)
	sizer()
	update_cursor()
	
func create_empty_menu(num, place = true):
	
	for n in range(0,num):
		instance_item("--")
		#items[n].setlabel(list[n])
		#optbase's own ready function calls setlabel after instancing... sometimes... seemingly fixed
		items[n].add_data("index", n)
		#items[n].add_data("data", list[n])
	
	active_all()
	if place: place_items(0)
	sizer()
	update_cursor()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

#FIX THAT FOUR, AND USE ACTIVES (:
func update_cursor(val = "Z"):#passes in "UP,"DW","LF","RT"
	var v = 0
	match val:
		"Z":
			pass
		"UP":
			v = 2
		"DW":
			v = -2
		"LF":
			v = -1
		"RT":
			v = 1
		#etc
	
	#l and r scroll through the whole menu rather than switching cols. fix later i guess
	
	cursor = (cursor + v + activescount) % activescount#negatives still break...
	#print(cursor)
	#for n in range(0,4):
			#items[n].highlight(n==cursor)
	
	for n in range(0,activescount):
		actives[n].highlight(n==cursor)
