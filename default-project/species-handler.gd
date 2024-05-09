extends "res://global/base-species-handler.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("test")
	#pass

#use sp.tagname to access project-defined tags (:

#there is nothing here yet (:

#this can be super-ified
func getstg(id, tag):
	#if tag is a new one that needs special definition, eg an additional base stat, get it,
	#else pass to base getstg and return that
	#as an example...
	if tag == sp.xstat:
		var bases = getbases(id)
		return( bases.get(tag, 5) )
		#this will always return 5 because it's just an example andnot implemented for anything lol
		#default doesn't have any special tags of course, so don't use that
	#if lots of new tags are added, consider using a match statement
	#else...
	return super.getstg(id,tag)
