extends dscripttags

const moves = {#not const lol... or is it?
	"red1":{
		dt.tgname: "red1",
		dt.tgtype: tgred,
		dt.tgdamage: 15,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"red2":{
		dt.tgname: "red2",
		dt.tgtype: tgred,
		dt.tgdamage: 10,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"yel1":{
		dt.tgname: "yellow1",
		dt.tgtype: tgyel,
		dt.tgdamage: 15,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"yel2":{
		dt.tgname: "yellow2",
		dt.tgtype: tgred,
		dt.tgdamage: 10,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"green1":{
		dt.tgname: "green1",
		dt.tgtype: tggreen,
		dt.tgdamage: 15,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"green2":{
		dt.tgname: "green2",
		dt.tgtype: tgred,
		dt.tgdamage: 10,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"blue1":{
		dt.tgname: "blue1",
		dt.tgtype: tgblue,
		dt.tgdamage: 15,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"blue2":{
		dt.tgname: "blue2",
		dt.tgtype: tgblue,
		dt.tgdamage: 10,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"pur1":{
		dt.tgname: "purple1",
		dt.tgtype: tgpur,
		dt.tgdamage: 15,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	"pur2":{
		dt.tgname: "purple2",
		dt.tgtype: tgpur,
		dt.tgdamage: 10,
		dt.tgup: 10,
		dt.tgacc: 100,
	},
	
	
	
	#pseudomoves used for trainer actions etc
	"switch":
		{dt.tgpriority:SQsp},
		#will use target to define mon to be switched to. basically targetting a
		#party member instead of a field slot
	"run":
		{dt.tgpriority:SQsp},
	"item":
		{dt.tgpriority:SQsp},
	
	
	"error":{
		dt.tgname:"error",
	}

}


func _ready():
	for move in moves:
		moves[move].make_read_only()

func move_isvalid(id):
	#very simple
	#might add stuff to be excluded like the pseudomoves...
	var test = moves.get(id, moves["error"])
	return test[dt.tgname] != "error"

#the getter functions
func move_getmove(id):
	return moves.get(id, moves["error"])

#simple ones, but with some default/error checking
#should just use getmove
func move_getname(id):
	var ayy = moves.get(id, moves["error"])
	return ayy.get(dt.tgname, "error")

func move_gettype(id):#simple if error?
	var ayy = moves.get(id, moves["error"])
	return ayy.get(dt.tgtype, "simple")

func move_getprio(id):
	var ayy = moves.get(id, moves["error"])
	return ayy.get(dt.tgpriority, dt.SQ0)


#complex ones. effect handling probably handled in battle scripts
func move_getdmg(id):
	#values like -1 or 0 might indicate special damage calcs, non-damaging move, etc
	#these details will probably be handled in the battle script, probably
	return moves[id].get(dt.tgdamage, 7)


#if exists...
func move_geteffect(id):
	#if move .has(tgeffect): .has(tgeffchance)
	pass
