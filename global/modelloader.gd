@tool
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var strn = "res://pokemon-project/scenes-chars/serenahandlern.tscn"
	var temp
	if FileAccess.file_exists(strn):
		temp = load(strn).instantiate()
	else:
		temp = load("res://cyoob.tscn").instantiate()
	add_child(temp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
