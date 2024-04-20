extends Node

#var savefile
var save

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#load save file if it exists
	#there's probably/should be a versioning system, so check the save version
	#and load the correct save... loader to manage the save file
	#then load a save-varable-haver to hold the project-specific stuff.
	#for now it's a dummy script so just load it up
	save = load("res://savefile_dummy.gd")

func getthing(st):
	#if save.has(st): return save.st
	#else return null and wave an error at the user
	#ought to alert the user is the prop dpesn't exist, but if the prop
	#exists but currently is null it's fine
	if st in save:
		return save.st
	else:
		print(st + "error oh no ")
		return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
