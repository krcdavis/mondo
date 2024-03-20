extends "res://global/menubase.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func place_items(xx=-1,yy=-1,oddset=0):
	var xxx
	if xx == -1:
		xxx = xd
	else:
		xxx = xx
	#this works but the other way doesn't i guess (shrug)
	
	var yyy = yy
	if yy == -1:#use default yd from menubase... or optbase
		#i don't know why this doesn't seem to be working
		yyy = yd
	#do the same for x except don;t because it doesn't work ):
	
	var n = 0
	for it in items:
		#for y, add oddset*(n%1)
		it.position += Vector2(xxx*(n%2),yy*int(n/2) + oddset*(n%2))
		n += 1

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
