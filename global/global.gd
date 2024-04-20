extends Node

#temp
const playername = "Suzanne"

const n = .05
var rng
var head

var flagscamphrfirstenter = true

#hmm
var textreg0 = ""
var textreg1 = ""
var textreg2 = ""
var textreg3 = ""
var textreg4 = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	
	#print(d.species.getname("lileaf"))#yay!!
	#print(d.moves.getname("stunseed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
