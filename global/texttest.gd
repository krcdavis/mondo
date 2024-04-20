@tool
extends RichTextEffect
class_name RichTextTest

# Syntax: [testx] i guess idk

# Define the tag name.
var bbcode = "testx"
var do = true

func _process_custom_fx(char_fx):
	if do:
		print(gb.name)
		do = false
		return true
