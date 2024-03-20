extends Area3D
#interact sphere (is probably not a sphere)

var timer = .06
#@onready var col = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#get colliding/overlapping bodies, check each for an interaction script
	#do some sort of priority to decide which one to call if multiple
	#then after a frame or two, unload


# Called every frame. 'delta' is the elapsed time since the previous frame.
#exist for a frame or two then die
#func _process(delta):
	#timer -= delta
	##print(timer)
	#if timer <= 0:
		#queue_free()
