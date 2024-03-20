extends mscripttags#hope this never needs any node3d functs

var mode = "you"
#current map and temp map
var cmap
var tmap
var wilds = {}
var btlw1v1
#things
@onready var you = $you
@onready var hud = $hud
@onready var text = $hud/textbox

signal scrdone
signal scriptdone

# Called when the node enters the scene tree for the first time.
func _ready():
	you.head = self
	cmap = $map
	text.visible = false
	gb.head = self#i
	#project data -> startup map -> change map to that
	#changemap(["default-project/scenes-maps/map1","Node3D"])
	#changemap(["pokemon-project/scenes-maps/010vani_aqu/vani_aqu_0001","yourdoor"])
	changemap(["pokemon-project/scenes-maps/000junk/010_vville-early","yourdoor"])
	#res://.tscn
	#also from project data, get and load basic battle scene(s)
	btlw1v1 = load(d.get_datapath() + "/scenes-btl/btlw_1_on_1.tscn").instantiate()#need fix naem
	add_child(btlw1v1)
	btlw1v1.visible = false#etc
	btlw1v1.head = self


# process...
#func _process(delta):
	#pass

#var datapath = "res://"#...
func changemap(mapdata):#[map tscn name, point name]- point can be ignored for now (:
	#maybe change to map, point = null
	#for now, the whole path is being passed in
	var temp = load("res://" + mapdata[0] + ".tscn")
	tmap = temp.instantiate()
	add_child(tmap)
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


func init_battle(list):
	pass
	#list will be like [0,1] or whatever- array of IDs of grass patches player was in contact
	#with when battle triggered. cross-ref with wilds which is current map's wild data
	#to get a list of possible encounters, select one, set up wild battle and call newbattle()
	
	#other types of battle will of course be implemented later...
	#consider eg if you have double battle grass like bw, player might be in contact w/
	#both that and normal grass, etc...
	
	#in terms of the battle scene, as much as possible is done either here or 
	#in battle basis/utils so it doesn't need to be duplicated across battle types...
	
	var wildlist = []
	for l in list: wildlist += wilds[l]
	#print(wildlist)
	var selection = wildlist[ gb.rng.randi() % wildlist.size() ]
	#print(selection)
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
	var storemode = mode
	mode = "script"
	for script in scripta:
		onescript(script)
		await self.scrdone
		#print("AAA")
	await create_tween().tween_interval(.0002).finished#lol
	mode = storemode
	emit_signal("scriptdone")

#this also means simple one-line scripts can be played on their own
func onescript(script):
	#this is done twice but it's fine (:
	var storemode = mode
	mode = "script"
	#also, player's walking animation should be stopped.
	match script[typ]:
		txt:#throw some text on the barbie
			if script.get(nme):
				text.setname(script[nme])
			else:
				text.hidename()
			text.textplay(script.get(txt,"line missing ):"), script.get("clear",false))
			#if menu, don't clear by default?...
			#if wait == menu (and next entry is menu?) await menu, else
			#or, package menu in text script itself
			await text.textover
		anm:
			pass
			#something in here is broken (:
			#if not script.get(trg): error
			#print(script.get(trg))
			#else if cmap no have actors; error
			#else if not cmap.actors.get( script[trg] ): error
			#actors should be set up in a certain way
			#also add way to pass in anim name directly
			cmap.actors[script[trg]].anim.play( cmap.actors[script[trg]].anims[script[anm]] )
			#if wait: wait, else wait anyway because otherwise it breaks
			#also if anim loops don't wait...
			#if script.get(wait,false): await cmap.actors[script[trg]].anim.animation_finished
			#else:
			await create_tween().tween_interval(.0002).finished#lol
		twn:
			#if not script.get(trg): error
			#else if map no have actors; error
			#else if not map.actors.get( script[trg] ): error
			var tween = create_tween()
			tween.tween_property( cmap.actors[script[trg]], script[prop], script[end], script[tme] )#.st_trans( script[thing] )
			if script.get(wait,false): await tween.finished
			else: await create_tween().tween_interval(.0002).finished#lol
	
	mode = storemode
	emit_signal("scrdone")

