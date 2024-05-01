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
@onready var phud = $pausemenu
@onready var text = $hud/textbox

var targets = {}

signal scrdone
signal scriptdone

# Called when the node enters the scene tree for the first time.
func _ready():
	you.head = self
	targets = {
	"you":you,
	"playercam":you.camera,#camera itself
	"you-campt":you.campt#default camera location which shouldn't be moved
	}
	
	hud.head = self
	gb.currenttext = text#or point to textbox?
	phud.head = self
	phud.visible = false
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
	#temporarily hardcoded
	var btemp = load(d.get_datapath() + "/scenes-btl/btlw_1_on_1.tscn").instantiate()#need fix naem
	battlescenes["btlw1v1"] = btemp
	add_child(btemp)
	btemp.visible = false#etc
	btemp.head = self
	
	#and
	btemp = load("res://default-project/scenes-btl/btlw2on1.tscn").instantiate()
	battlescenes["btlw2v1"] = btemp
	add_child(btemp)
	btemp.visible = false#etc
	btemp.head = self
	

# process...
#func _process(delta):
	#pass

func pause():
	#pause map (everything in it should be set to inherit), player, whatever else
	#pausing is handled by player and from there is limited to when the player can usually act
	#(eg, when free to walk around, when not in the middle of jumping off a ledge, etc)
	#and show/activate the pause menu
	
	phud.visible = true
	storemode = mode#maybe rename this pause-storemode or stg
	mode = "pause"
	phud.mode = phud.MAINM

func unpause():
	#undoes pause, on closing the pause menu.
	phud.visible = false
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
		wilds = cmap.wildstest
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

func add_battlescene(path, bnme):
	#to do: add errorchecking lol
	var btemp = load(path).instantiate()
	battlescenes[bnme] = btemp
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
	var btsc = selection.get(typ, "btlw1v1")
	#set active battlescene variable?...
	battlescenes[btsc].wtemp = [selection["sp"],selection["lv"]]
	#btlw1v1.wtemp = selection
	cmap.visible=false
	gb.currenttext = battlescenes[btsc].textbox
	battlescenes[btsc].newbattle()

#activates a previously setup battle with specified scene...
#this is the old one
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
	gb.currenttext = text

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
		
		#for target, these can have map-specific ones or universal ones (player,
		#player's camera, player camera base point). define something for that
		anm:
			#TODO: error checking/handling at various levels. also, define a setup for animatable characters/objects so the animation player can be consistently accessed
			#if not script.get(trg): error
			#var targ = script[trg]
			var target = null
			if script[trg] == "you":#can't animate camera lmao. change back if anything else added
				target = targets[script[trg]]
			#else if cmap doesn't have actors; error
			else:
				target = cmap.actors.get( script[trg] )
			#if target is null, error.

			#make sure target has anim node
			target.anim.play( target.anims[script[anm]] )

			#if wait: wait, else wait anyway because otherwise it breaks
			#also if anim loops don't wait...
			#if script.get(wait,false): await cmap.actors[script[trg]].anim.animation_finished
			#else:
			#at various stages a single-frame wait is required to prevent issues... this is how they're implemented
			await create_tween().tween_interval(.0002).finished#lol
		twn:#tween
			#if not script.get(trg): error
			
			#var targ = script[trg]
			var target = null
			if script[trg] in targets.keys():
				target = targets[script[trg]]
			#else if map doesn't have actors; error
			else:
				target = cmap.actors.get( script[trg] )
			#if target still null, error
			
			#if property is rotate, try to get target's vis node and use that
			#no error if not found, it's just preferred

			#possible end types are hardcoded value (vec 3 in 3d), a predef's pos,
			# an actor's pos, an add/subtract from current value.
			#give these sept tags: endval, endtrg, endmod (as in modify) ?
			#who gets the simple "end" tag, value? that's basically how it is now anyway
			#also rotation should have a look-at type. do that later
			var endval = null
			if script.get("endtrg"):#try get target from predefs or actors
				#var endtrg = script["endtrg"]
				var endtarget = null
				if script["endtrg"] in targets:#.keys()?
					endtarget = targets[script["endtrg"]]
				#else if map doesn't have actors; error
				else:
					endtarget = cmap.actors.get( script["endtrg"] )
				if endtarget:
					#property should be position, rotation, maybe scale- all global
					match script[prop]:
						"global_position","position":
							endval = endtarget.global_position
						"rotation":
							pass
						"scale":
							pass
				
			#no error if not found, yet
			#technically should error if script has a target that can't be found,
			#or is somehow missing a property, but if stg else works it's sort of fine


			#else if "endmod":# get matching val from target and calc
			else: if end: endval = script[end]
			#now if endval still null, error
			var tween = create_tween()
			tween.tween_property( target, script[prop], endval, script[tme] )#.st_trans( script[thing] )
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

