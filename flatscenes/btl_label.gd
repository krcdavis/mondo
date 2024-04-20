extends Sprite2D

@onready var label = $Label
@onready var hpbar = $hpbar
@onready var lvlabel = $lvlabel

#flags...
var hasexpbar = false#

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func highlight(setting = true):
	$Arr.visible = setting

func settext(tt = "aaa"):
	label.text = tt

func sethp(maxm,val):
	hpbar.max_value = maxm
	hpbar.value = val

func updhp(val):
	hpbar.value = val

func setlv(lv):
	lvlabel.text = "Lv. "+str(lv)
