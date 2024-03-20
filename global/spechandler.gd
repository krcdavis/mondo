extends "res://monstar-project/species.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	for sp in species:
		species[sp].make_read_only()
		#do sub-units like base stats and moves need to be done sep?


#two possible errors: the species doesn't exist at all, or exists but is missing parts
#"nandummy" should have default entries for all parts...

func getspecies(spec):
	return species.get(spec, "nandummy")

func getname(spec):
	var specitemp = getspecies(spec)
	return specitemp.get(tgname,"error")

#this probably needs to match tag to send back the right default
func getstg(spec, tag):
	var specitemp = getspecies(spec)
	
	#if in tgatk, etc, get tgbase[tag], else...
	if tag in [tghp,tgatk,tgdef,tgspeed,tgluck,tgskill]:
		
		return specitemp[tgbase][tag]
	
	return specitemp[tag]
