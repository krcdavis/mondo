extends StaticBody3D

@export var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_value(1,false)
	set_collision_layer_value(2,true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass

func is_grass():
	pass
