extends scripttags

var species#le pointer
var sp#loads species file, can be used to access extended data tags

const default = {
		tgname:"default",
		tgmodel:"asdf",
		tgtype:tgNOTYPE,
		tgbase:{
			tghp:8,
			tgatk:6,
			tgdef:6,
			tgspeed:6
		},
		tgability:"none",
		tgbmoves:["none","none","none","none",]
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("aaaaa")

#as much as possible is done here so it can be shared between all projects (:
#setup is called from data-handler after creation because ready isn't called because reasons

func setup(_path):
	sp = d.species
	species = d.species.species
	
	for spec in species:
		species[spec].make_read_only()


func getspecies(id):
	return species.get(id, default)

func getname(id):
	return getspecies(id).get(tgname,"error")

func getbases(id):
	var spec = getspecies(id)#will get default if species completely undefined, but...
	return spec.get( tgbase, default[tgbase] )#if species returned doesn't have tgbase, default

#only called by project-specific species-handler... base stats handled there?
func getstg(id, tag):
	#verify species and tag pls
	var spget = getspecies(id)
	
	#if in tgatk, etc, get tgbase[tag], else...
	#update this with getbases plz
	if tag in [tghp,tgatk,tgdef,tgspeed]:
		#return getbases(id).get(tag, default[tgbase][tag])
		return spget[tgbase][tag]
	
	return spget[tag]



