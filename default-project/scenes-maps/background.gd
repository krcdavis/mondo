extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$Cube.get_active_material(0).uv1_offset = Vector3(.25,-.25,0)
	#tween uv1_offset[0] and [1]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
