extends Node2D

var partymenu

# Called when the node enters the scene tree for the first time.
func _ready():
	partymenu = twocolumnenu.new()
	add_child(partymenu)
	#somehow tell new menu to use res://flatscenes/partymenumonoptbase.tscn over optbase...
	
	#functions not yet defined
	partymenu.set_optbase("res://flatscenes/partymenumonoptbase.tscn")
	partymenu.create_empty_menu(6,false)#or rather, pass in globally defined party max
	#dude add a back button lol
	#to do: not this
	partymenu.place_items(5,8,15)
	partymenu.position = $Node2D.position
	#then for each party member, update and activate its menu item
	#for mon in party.party:
	
	update_party()

func update_party():
	pass
	#party is currently just an array of mons. at some point it will be
	#something more sophisticated, but for now...
	var n = 0
	for mon in party.party:
		update_mon(n)
		n += 1
	

func update_mon(n):
	pass
	partymenu.items[n].setlabel("a")
	partymenu.items[n].setlevel(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
