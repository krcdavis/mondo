extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	if not OS.is_debug_build():
		self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
