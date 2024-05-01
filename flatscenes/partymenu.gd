extends Node2D

var partymenu
var back

var menuhead

# Called when the node enters the scene tree for the first time.
func _ready():
	partymenu = twocolumnenu.new()
	add_child(partymenu)
	#somehow tell new menu to use res://flatscenes/partymenumonoptbase.tscn over optbase...
	
	#add a single button before setting optbase, append that last, use as back
	partymenu.instance_item("Back")
	#this will be [0] of items and last of actives. so for update_party just start w/ n=1
	#that messes up the measurement for placing though, hmm
	back = partymenu.items[0]
	partymenu.items.clear()
	
	#functions not yet defined
	partymenu.set_optbase("res://flatscenes/partymenumonoptbase.tscn")
	partymenu.create_empty_menu(6,false)#or rather, pass in globally defined party max
	partymenu.items.append(back)#oh boy
	#dude add a back button lol
	#to do: not this
	partymenu.place_items(5,8,15)
	partymenu.position = $Node2D.position
	back.position = $Node2D2.position
	update_party()

func update_cursor(dir):
	#if cursor in right column of menu and right is pressed, send cursor to back button
	#ie last in actives. if cursor on back button apply some other special rules.
	#else... base update, but with actives count - 1?
	partymenu.update_cursor(dir)
	print(partymenu.cursor)

func update_menu():
	update_party()

func update_party():
	partymenu.actives.clear()
	#party is currently just an array of mons. at some point it will be
	#something more sophisticated, but for now...
	var n = 0
	for mon in party.party:
		update_mon(n)
		partymenu.actives.append(partymenu.items[n])
		n += 1
	#i guess then just hide
	for m in range(n,partymenu.items.size()):
		partymenu.items[m].visible = false
	back.visible = true
	partymenu.actives.append(back)
	#navigation is broken lol
	partymenu.sizer()
	partymenu.update_cursor()

func update_mon(n):
	#check against size of party
	partymenu.items[n].setlabel(party.party[n].nname)
	partymenu.items[n].setlevel(party.party[n].level)

func execute_cursor():
	pass
	if partymenu.cursor == partymenu.activescount-1:#back
		menuhead.restate(menuhead.MAINM)
	else:
		menuhead.restate(menuhead.MONM,partymenu.cursor)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#pass
