extends Node3D

@onready var items = [$CanvasLayer/optbase,$CanvasLayer/optbase2]
var cursor = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#fade in?
	#opt2 deselect
	items[1].highlight(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"battletest temp 2/Circle_001".rotation.y += delta / 10
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		flip_cursor()
	else: if Input.is_action_just_pressed("ui_accept"):
		exec_cursor()

func flip_cursor():
	cursor = !cursor
	if cursor:
		items[0].highlight()
		items[1].highlight(false)
	else:
		items[0].highlight(false)
		items[1].highlight()

func exec_cursor():
	if cursor:#true = first option = intro sequence
		pass
		print("yes")
		#head.changemap(introseq)
	else:#false = second opt = jump right in
		pass
		print("no")
		#set up basic party
		#head.changemap(map1)

