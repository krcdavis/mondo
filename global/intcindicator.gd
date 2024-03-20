extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#set colis layers?... not necessary with area detecting player's colis.
	#or player's area even, that just has mask2 set to detect grass.
	self.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	#possibly the arrow bons or stg
	#when changed to hud sprite, keep sprite tracked to object's/point's unproject.


func _on_area_entered(area):
	pass # Replace with function body.
	#if it's player's area, show arrow
	if area.name == "player-area":
		self.visible = true



func _on_area_exited(area):
	pass # Replace with function body.
	#if player's, hide area.
	if area.name == "player-area":
		self.visible = false
