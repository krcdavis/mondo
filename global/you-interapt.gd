extends Node3D

#preload interasp interact sphere
#@onready var i = preload("res://global/interasp.tscn")
@onready var ip = $interasp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnsphere():
	#ip = i.instantiate()
	#add_child(ip)
	#
	##wait one frame then query sphere??
	#await create_tween().tween_interval(.0002).finished#lol
	
	var ir = ip.get_overlapping_bodies()
	for im in ir:
				print(im.name)
