extends dscripttags
var head

var textget = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func loadingritual():
	head.deactivate_player()
	$Camera3D.make_current()
	
	#play script
	head.scriptplay(script001)
	await head.scriptdone
	#activate name entry... ie just show it
	var nameget = true
	$LineEdit.visible=true
	while nameget:
		textget = await $LineEdit.text_submitted
		#print(textget)
		gb.textreg0 = textget
		head.scriptplay(script002)
		await head.scriptdone
		#head.hud.menuresult reacharound...
		if head.hud.menuresult == "Yes":
			nameget=false
			
		#else:
	d.save.playername = textget
	$LineEdit.visible=false
	head.scriptplay(script003)
	await head.scriptdone
	nameget = true
	$LineEdit.clear()
	$LineEdit.visible=true
	#and again
	while nameget:
		textget = await $LineEdit.text_submitted
		#print(textget)
		gb.textreg0 = textget
		head.scriptplay(script004)
		await head.scriptdone
		#head.hud.menuresult reacharound...
		if head.hud.menuresult == "Yes":
			nameget=false
	#and save name, and continue
	d.save.rivalname = textget
	$LineEdit.visible=false
	head.scriptplay(script005)
	await head.scriptdone
	d.save.firstloadmapflag = true
	head.changemap(["default-project/tscnsmaps/map2","door"])

const script001 = [
	{typ:txt,txt:"Welcome to the Mondo game engine demo!"},
	{typ:txt,txt:"This will showcase an overview of the engine's functions."},
	{typ:txt,txt:"Enter a name for your character.",dclr:true},
]
const script002 = [
	{typ:txt,txt:"You want the name %t0?",dclr:true},
	{typ:menu,menu:"yno"}
]
const script003 = [
	{typ:txt,txt:"So your name is now %pn. Great!"},
	{typ:txt,txt:"Now, enter a name for your rival.",dclr:true},
]
const script004 = [
	{typ:txt,txt:"Is that right?",dclr:true},
	{typ:menu,menu:"yno"}
]
const script005 = [
	{typ:txt,txt:"%pn! You're going to be a great monster demo player!"},
	{typ:txt,txt:"Now get out there and gettem!"},
]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
