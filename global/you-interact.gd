extends Area3D

var timer = 3

# now it just exists for like 3 frames, reports collisons from that time to global or stg then dies
#func _ready():
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if timer < 0:
		queue_free()
	else:
		timer -= 1
		#print(timer)
		#get colliding areas and like send them to head or something
		#for thing in collidings, if not in collected_collidings append

#lol
func is_interactprobe():
	pass
