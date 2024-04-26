extends mscripttags#hope this never needs any node3d functs

var mode = "you"
var storemode = ""#?
#current map and temp map
var cmap
var tmap
var wilds = {}
var btlw1v1#remove
var battlescenes = {}
#things
@onready var you = $you
@onready var hud = $hud
#@onready var phud = $pausemenu
@onready var text = $hud/textbox

signal scrdone
signal scriptdone

# Called when the node enters the scene tree for the first time.
func _ready():
	you.head = self
	hud.head = self
	#phud.head = self
	#phud.visible = false
	cmap = $map
	text.visible = false
	gb.head = self#i
	hud.visible = false
	#project data -> startup map -> change map to that
	changemap(["default-project/tscnsmaps/map1","door"])
	#changemap(["pokemon-project/scenes-maps/010vani_aqu/xy000_yourhouse","start"])
	#changemap(["pokemon-project/scenes-maps/010vani_aqu/010_vville_240418","yourdoor"])
	#changemap(["pokemon-project/scenes-maps/040camphr setup","Node3D"])
	#res://pokemon-project/scenes-maps/010vani_aqu/010_vville_240418.tscn
	
	#also from project data, get and load basic battle scene(s)
	btlw1v1 = load(d.get_datapath() + "/scenes-btl/btlw_1_on_1.tscn").instantiate()#need fix naem
	add_child(btlw1v1)
	btlw1v1.visible = false#etc
	btlw1v1.head = self

# process...
#func _process(delta):
	#pass

func pause():
	#pause map (everything in it should be set to inherit), player, whatever else
	#pausing is handled by player and from there is limited to when the player can usually act
	#(eg, when free to walk around, when not in the middle of jumping off a ledge, etc)
	#and show/activate the pause menu
	
	#phud.visible = true
	storemode = mode
	mode = "pause"

func unpause():
	#undoes pause, on closing the pause menu.
	#phud.visible = false
	mode = storemode

#var datapath = "res://"#...
var lastpoint = ""
func changemap(mapdata):#[map tscn name, point name]- point can be ignored for now (:
	#maybe change to map, point = null
	#for now, the whole path is being passed in
	var temp = load("res://" + mapdata[0] + ".tscn")
	tmap = temp.instantiate()
	add_child(tmap)
	lastpoint = mapdata[1]
	var snee = tmap.get_node_or_null(mapdata[1])
	if snee:#ideally, if you is undefined pos is undefined anyway, eg title screen
		$you.position = snee.position
		$you.vis.rotation = snee.rotation
		#$you.dirold = snee.rotation.y
		#next: add a set-rotation function to properly set dirold etc,so you don't turn weirdly on first move
	#queue free cmap
	if cmap:
		cmap.queue_free()
	cmap = tmap
	
	#all maps should have a head reference, maybe in a base script class
	#check map script for wild battle data and set something somewhere accordingly
	#if cmap has variable wilddata, load wilddata into ... here i guess
	#and set wilds=true, else clear wilds and set wild = false
	if "head" in cmap:#???
		cmap.head = self
	else:
		print("map missing head var")
	
	if "wilds" in cmap:
		#g.wild_map = true
		wilds = cmap.wilds
	else:
		#g.wild_map = false
		wilds = []#no cinnabar coast shenanigans here!!
	#eventually wilds will probably be a dict of arrays, with keys for "grass", "dark grass",
	#"red/blue/etc flowers", "surf", "old rod" etc etc
	
	#actors dict might be loaded up somewhere- list of pointers to models that have actions
	
	#for stuff that can only be done once head is set, causing errors if done in ready
	if cmap.has_method("loadingritual"):
		cmap.loadingritual()

func deactivate_player(mmode="a"):
	you.visible=false
	mode=mmode

func activate_player():
	you.visible = true
	mode = "you"

func add_battlescene(path, nme):
	#to do: add errorchecking lol
	var btemp = load(path).instantiate()
	battlescenes[nme] = btemp
	add_child(btemp)

#takes in the array of grass patch types the player was in contact with.
#gets corresponding wild lists, picks one- now a dict including battle scene type
func init_battle(list):
	#in terms of the battle scene, as much as possible is done either here or 
	#in battle basis/utils so it doesn't need to be duplicated across battle types
	
	var wildlist = []
	for l in list: wildlist += wilds[l]
	#print(wildlist)
	var selection = wildlist[ gb.rng.randi() % wildlist.size() ]
	#print(selection)
	#var btsc = selection.get(typ, "btlw1v1")
	#b[btsc].wtemp = [selection["sp"],selection["lv"]]
	btlw1v1.wtemp = selection
	cmap.visible=false
	btlw1v1.newbattle()

#activates a previously setup battle with specified scene...
func activate_battle(_scene = null):
	cmap.visible = false
	#do stg to reset player anim btw
	#scene.newbattle()
	btlw1v1.newbattle()#this does some amount of the stuff...
	#namely: record current cam, set battle cam to current, head.mode to battle

func deactivate_battle():
	#battlescene itself handles unloading models etc, then calls this
	#battlescene also hides self and resets camera
	
	#unhide map, free player/switch mode
	cmap.visible = true
	mode = "you"

#i guess this will go here- takes an array of dicts
func scriptplay(scripta):
	var storemode1 = mode
	mode = "script"
	for script in scripta:
		onescript(script)
		await self.scrdone
		#print("AAA")
	await create_tween().tween_interval(.0002).finished#lol
	mode = storemode1
	emit_signal("scriptdone")

#this also means simple one-line scripts can be played on their own
func onescript(script):
	#this is done twice but it's fine (:
	var storemode2 = mode
	mode = "script"
	#also, player's walking animation should be stopped in some cases.

	match script[typ]:
		txt:#throw some text on the barbie
			hud.visible = true
			if script.get(nme):
				text.setname(script[nme])
			else:
				text.hidename()
			var t = script.get(txt,"line missing ):")
			#text replacement is done by textbox code
			text.textplay(t, script.get(dclr,false))
			#TODO: implement spawning menus along/after a line of text (eg answering yes/no to a question)
			#if menu, don't clear by default?...
			#if wait == menu (and next entry is menu?) await menu, else
			#or, package menu in text script itself
			await text.textover
			hud.visible = script.get(dclr,false)
		anm:
			#TODO: error checking/handling at various levels. also, define a setup for animatable characters/objects so the animation player can be consistently accessed
			#if not script.get(trg): error
			#else if cmap doesn't have actors; error
			#else if not cmap.actors.get( script[trg] ): error
			cmap.actors[script[trg]].anim.play( cmap.actors[script[trg]].anims[script[anm]] )
			#if wait: wait, else wait anyway because otherwise it breaks
			#also if anim loops don't wait...
			#if script.get(wait,false): await cmap.actors[script[trg]].anim.animation_finished
			#else:
			#at various stages a single-frame wait is required to prevent issues... this is how they're implemented
			await create_tween().tween_interval(.0002).finished#lol
		twn:#tween
			#if not script.get(trg): error
			#else if map doesn't have actors; error
			#else if not map.actors.get( script[trg] ): error
			var tween = create_tween()
			tween.tween_property( cmap.actors[script[trg]], script[prop], script[end], script[tme] )#.st_trans( script[thing] )
			if script.get(wait,false): await tween.finished
			else: await create_tween().tween_interval(.0002).finished#lol
		#TODO: add things like play sound effect, change music, menu, ...
		menu:
			pass
			match script.get(menu,"A"):
				"yno":
					hud.yesno()
			
			await hud.activemenu.menuresult
			
	
	mode = storemode2
	emit_signal("scrdone")

