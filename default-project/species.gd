extends dscripttags

const species = {
	"cube":{
		tgname:"Cube",
		tgmodel:"cube",
		tgtype:tgred,
		tgbase:{
			tghp:8,
			tgatk:6,
			tgdef:6,
			tgspeed:6
		},
		tgability:"none",
		tgbmoves:["red1","red2","green2",""],
		tglmoves: [
			[0,"red1"],
			[0,"green2"],
			[8,"red2"],
			[15,"yel2"],
		]
	},
	"cone":{
		tgname:"Cone",
		tgmodel:"cone",
		tgtype:tgyel,
		tgbase:{
			tghp:8,
			tgatk:6,
			tgdef:6,
			tgspeed:6
		},
		tgability:"none",
		tgbmoves:["yel1","yel2","red2","",],
		tglmoves: [
			[0,"yel1"],
			[0,"green2"],
			[8,"red2"],
			[15,"yel2"],
		]
	},
	"sphere":{
		tgname:"Sphere",
		tgmodel:"sphere",
		tgtype:tgblue,
		tgbase:{
			tghp:8,
			tgatk:6,
			tgdef:10,
			tgspeed:6
		},
		tgability:"none",
		tgbmoves:["blue1","blue2","pur2","",],
		tglmoves: [
			[0,"blue1"],
			[0,"blue1"],
			[8,"pur2"],
			[15,"green2"],
		]
	},
	"icos":{
		tgname:"Icosphere",
		tgmodel:"icos",
		tgtype:tgpur,
		tgbase:{
			tghp:8,
			tgatk:6,
			tgdef:6,
			tgspeed:6
		},
		tgability:"none",
		tgbmoves:["pur1","pur2","yel2","sdgg",],
		tglmoves: [
			[0,"pur1"],
			[0,"green2"],
			[8,"pur2"],
			[15,"yel2"],
		]
	},
	"donut":{
		tgname:"Donut",
		tgmodel:"donut",
		tgtype:tggreen,
		tgbase:{
			tghp:8,
			tgatk:6,
			tgdef:6,
			tgspeed:6
		},
		tgability:"none",
		tgbmoves:["green1","green2","blue2","",],
		tglmoves: [
			[0,"green1"],
			[0,"green2"],
			[8,"blue2"],
			[15,"yel2"],
		]
	},
	"arock":{
		tgname:"A Rock",
		tgmodel:"arock",
		tgtype:tggreen,
		tgbase:{
			tghp:80,
			tgatk:1,
			tgdef:60,
			tgspeed:6
		},
		tgability:"none",
		tgbmoves:["green1","green2","blue2","",],
		tglmoves: [
			[0,"red1"],
			[0,"green2"],
			[8,"red2"],
			[15,"yel2"],
		]
	},
	
	"default":{
		tgname:"default",
		tgmodel:"GETTHEERRORCUBE",
		tgtype:tggreen,
		tgbase:{
			tghp:8,
			tgatk:6,
			tgdef:6,
			tgspeed:6
		},
		tgability:"none",
		tgbmoves:["green1","green2","blue2","",]
	},
	
	"error":{
		
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
