extends scripttags

var types#le pointer
var tp#loads species file, can be used to access extended data tags

#no default needed, just return 1 if base type not found

# Called when the node enters the scene tree for the first time.
func _ready():
	print("b t h loaded")
	var dp = d.get_datapath()
	#try loading dp/types.gd
	#species = load(_datapath + "/species.gd").new()#ok
	
	tp = load(dp + "/types.gd").new()
	add_child(tp)
	types = tp.types

func get_rel(def,atk):
	var type = types.get(def, null)
	if not type: return 1
	#else...
	return type.get( atk, 1 )
