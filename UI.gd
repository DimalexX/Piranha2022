extends CanvasLayer

const crForBoost = 5000
onready var hp_progress = $HPProgress
onready var hp_label = $HP
onready var credits_label = $Credits
onready var game_over_label = $GameOver
onready var start_label = $Start
onready var parent = get_parent()

var max_hp = 1000 setget set_max_hp
var credits = 0 setget set_credits
var cur_hp = 1000 setget set_cur_hp
var boostcredits = crForBoost


func set_max_hp(m_hp):
	max_hp = m_hp
	hp_progress.max_value = m_hp
	update_hp_label()


func set_credits(c):
	if c < credits:
		boostcredits = c + crForBoost
	credits = c
	credits_label.text = str(c)
	if credits >= boostcredits:
		boostcredits += crForBoost
		parent.add_boost()


func set_cur_hp(c_hp):
	if c_hp <= 0:
		cur_hp = 0
		game_over_show("GAME OVER")
		start_label.show()
	else:
		cur_hp = c_hp
	hp_progress.value = cur_hp
	update_hp_label()


func game_over_show(s):
	game_over_label.text = s
	game_over_label.show()


func update_hp_label():
	hp_label.text = str(cur_hp) + "/" + str(max_hp)


func _unhandled_input(event):
	if start_label.visible and event.is_action_pressed("ui_accept"):
		if cur_hp <= 0:
			get_tree().reload_current_scene()
		else:
			start_label.hide()
			game_over_label.hide()
			parent.set_pause_mode(false)


#var rng = RandomNumberGenerator.new()
#func _ready():
#	rng.randomize()
#	rng.randi
#
#var arr = [0, 0, 0, 0]
#var r
#func _process(delta):
#	r = rng.randi()%4
#	arr[r] += 1
#	print(r)
#	print(arr)
