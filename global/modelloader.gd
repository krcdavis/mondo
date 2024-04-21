@tool
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var strn = "res://pokemon-project/scenes-chars/serenahandlern.tscn"
	var temp
	if FileAccess.file_exists(strn):
		temp = load(strn).instantiate()
	else:#res://cyoob.tscn
		temp = load("res://default-project/scenes-etc/you_ball_1.tscn").instantiate()
	add_child(temp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
