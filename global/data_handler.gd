extends scripttags

const projectname = "jmonstar-project"

var sph
var species
var moves
var configs
var types
var abilities
var maps
var b_engine
var save
#currently maps are a mix between pokemon and monstars ones...
#using full strings for head.changemap
#could autoload the map list actually

var _datapath

# Called when the node enters the scene tree for the first time.
func _ready():
	#res://monstar-project/
	print("hjeolp")
	_datapath = "res://" + projectname + "/"
	#if folder no real, replace with default-project
	if not DirAccess.open(_datapath):
		_datapath = "res://default-project/"
	else:
		print("good")
	
	#these should each try-and-error first, for in-progress projects
	species = load(_datapath + "/species.gd").new()#ok
	sph = load(_datapath + "/species-handler.gd").new()#ok
	sph.setup(_datapath)
	moves = load(_datapath + "/moves-handler.gd").new()#ok
	configs = load(_datapath + "/configs.gd").new()#ok
	#types = load(_datapath + "/types-handler.gd").new()#ok
	#abilities = load(_datapath + "/abilities-handler.gd").new()#ok
	#maps = load(_datapath + "/maps-handler.gd").new()#ok
	#res://default-project/battle-engine.gd
	b_engine = load(_datapath + "/battle-engine.gd")#will be new-ed by the battlescene
	
	#this is the sort of pattern that should be used for all loads, but i'm lazy
	#if debug use fileaccess, else
	if OS.is_debug_build():
		if FileAccess.file_exists(_datapath + "/types-handler.gd"):
			types = load(_datapath + "/types-handler.gd").new()
		else:
			types = load("res://global/base-types-handler.gd").new()
	else:
		types = load(_datapath + "/types-handler.gd")#.new()#uh hmm
		if types:#if null/unfound
			types = types.new()
		else:
			types = load("res://global/base-types-handler.gd").new()
	add_child(types)#calls ready() so use that to set up types.gd and such (:
	
	#save.gd
	if OS.is_debug_build():
		if FileAccess.file_exists(_datapath + "/save.gd"):
			save = load(_datapath + "/save.gd").new()
			add_child(save)
		#else, leave it for now...
	else:
		save = load(_datapath + "/save.gd")
		if save:
			save = save.new()
			add_child(save)
		#else:

func get_datapath():
	return _datapath#ok

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
