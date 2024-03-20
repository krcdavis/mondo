extends "res://global/scripttags.gd"

var party = []#array of mon objects
var partyin = [ ["magnut",13,-1],["riffraft",20,-1],["flyder",20,-1],["slowcone",10,-1] ]#for loading...

#next: get default party data from a data folder file... configs.gd time

func _ready():
	#get d.configs.dfparty, with some error checking
	partyin = d.configs.dfparty
	
	setup_party(partyin)

func setup_party(inn):#[[],[],[]]
	var count = 0
	for thing in inn:
		party.append(Monster.new())
		party[count].setup_species_level(thing[0],thing[1], thing[2])
		count += 1
		#set temp?
		
		#print( g.lspecies.getstg(thing[0],dt.tgmodel) )#well now it works
	#print(party.size())
