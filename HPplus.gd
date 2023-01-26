extends Button


var credits
var cur_level
var max_level


func _ready():
	credits = 2000
	cur_level = 1000
	max_level = 1000


func update_state(cred, clevel, mlevel):
	if clevel == -1:
		clevel = cur_level
	if mlevel == -1:
		mlevel = max_level
	disabled = (cred < credits) or (clevel >= mlevel)
	if disabled:
		$MarginContainer.modulate.a = .5
	else:
		$MarginContainer.modulate.a = 1
	$MarginContainer/VBoxContainer/HBoxContainer/credits.text = str(credits)
	$MarginContainer/VBoxContainer/Level.text = str(clevel)+"/"+str(mlevel)
