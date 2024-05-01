extends "res://global/longmenu.gd"

const baseopts = ["Trainer card","Party","Bag","Options","Return"]

const tcard = "Profile"
const prty = "Party"
const bagg = "Bag"
const sav = "Save"
const optis = "Settings"
const dbug = "Debug"
const back = "Go Back"

var mode = ""
var menuhead

# actually, the menu should be regenerated on command, as options available change a lot more
# eg, before you obtain your first mon, the party option is just gone
func _ready():
	for n in range(0,7):
		instance_item("e")
		#actives.append( items[n] )
	place_items(6)
	#active_all()
	sizer()
	#update_cursor()
	update_menu()
	mode = "pauseoptions"

#var actives2 = []
#base actives has a slightly different function, so...

func update_menu():
	actives.clear()
	#based on current game state, set the menu up.
	#think I'll instanciate ~7 opts, reuse them, outright hide ones not being used
	#trainer card/profile should always be available
	var n = 0
	add_item(n,tcard)
	
	#party option should only appear if the first mon has been recieved.
	#there's no such flag yet, so just
	if true:
		n += 1
		add_item(n,prty)
	
	#bag should always be available
	n += 1
	add_item(n,bagg)
	#you would then de-activate it if the bag is temporarily unavailable for example
	#or maybe not, you might want to inform the player why they can't bag
	#anyway, n wouldn't be decremented because the option is still visually changed,
	#but bag would be popped from actives so it couldn't be scrolled to
	#eh, worry about it later
	
	#save, etc
	n += 1
	add_item(n,sav)
	
	#settings, etc
	n += 1
	add_item(n,optis)
	
	#and back
	n += 1
	add_item(n,back)
	
	#and debug...
	if true:
		n += 1
		add_item(n,dbug)
	
	#from n+1 to max (7), visible = false
	for m in range(n+1,7):
		items[m].visible = false
	
	#print(actives2)
	sizer()
	update_cursor()

func add_item(n,stri):
	items[n].activate(true,stri)
	#actives2.append(stri)
	actives.append(items[n])
	items[n].clear_data()
	items[n].add_data("key",stri)

func restate(newstate):
	pass

func execute_cursor():
	var key = actives[cursor].get_data("key")
	print(key)
	match key:
		tcard:
			print(tcard)
		prty:
			menuhead.restate(menuhead.PARTYM)#party
			#actually, send restates to menuhead
		bagg:
			print(bagg)
		optis:
			print(optis)
		back:
			menuhead.unpause()
			print(back)


#func _process(_delta):
	#pass
	#and we're sending this off to pausemenu
