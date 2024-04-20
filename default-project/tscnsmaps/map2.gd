extends dscripttags

var head

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#if flag, first event...
	if d.save.firstloadmapflag:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_area_3d_body_entered(body):
	if body.name == "you":
		head.changemap(["default-project/tscnsmaps/map1","Node3D"])



func _on_rival_colision_area_entered(area):
	#if interact probe, interact.
	if area.name == "interact":
		print("hi")
