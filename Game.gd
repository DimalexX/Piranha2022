extends Node2D


enum AsteroidSize {
	Small, Medium, Large
}


const Bomb = preload("res://BoostBomb.tscn")
const HPplus = preload("res://BoostHPplus.tscn")
const Boost = preload("res://BoostBoost.tscn")
const Credits = preload("res://BoostCredit.tscn")
const LargeAsteroid = preload("res://AsteroidLarge.tscn")
const MediumAsteroid = preload("res://AsteroidMedium.tscn")
const SmallAsteroid = preload("res://AsteroidSmall.tscn")
const UFO = preload("res://UFO.tscn")
const ship_start_position = Vector2(683, 650)

onready var ui = $UI
onready var shop = $UI/Shop
onready var ui_start = $UI/Start
onready var music_player = $MusicPlayer
onready var ship = $Spaceship
onready var start_points = [$P01, $P02, $P03]

var prev_music = 0
var play_music = true
var level = 1


func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_level()
	ui_start.show()
	ui.game_over_show("LEVEL %02d" % level)
	next_music()
	ship.reset_state = true
	set_pause_mode(true)
	
	
func set_pause_mode(mode):
	if mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		yield(get_tree().create_timer(0.05), "timeout")
		ship.is_paused = true
		get_tree().paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		ship.is_paused = false
		get_tree().paused = false


func add_credits(c):
	ui.credits = ui.credits + c


func add_asteroids(a_size, a_num, a_pos, a_level):
	var new_a
	for _i in range(a_num):
		match a_size:
			AsteroidSize.Large:
				new_a = LargeAsteroid.instance()
			AsteroidSize.Medium:
				new_a = MediumAsteroid.instance()
			AsteroidSize.Small:
				new_a = SmallAsteroid.instance()
		new_a.position = a_pos
		new_a.level = a_level
		call_deferred("add_child", new_a)


func add_boost():
	var i = randi()%4 
	var b
	if i == 0:
		b = Bomb.instance()
	elif i == 1:
		b = HPplus.instance()
	elif i == 2:
		b = Boost.instance()
	elif i == 3:
		b = Credits.instance()
	b.position = Vector2(rand_range(66, 1300), rand_range(66, 700)) #1366 768
	call_deferred("add_child", b)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("music"):
		play_music = not play_music
		if play_music:
			music_player.stream_paused = false
		else:
			music_player.stream_paused = true


func _on_MusicPlayer_finished():
	next_music()


const num_of_mus = 5
func next_music():
	var i
	if prev_music == 0:
		i = randi()%num_of_mus + 1
		prev_music = i
	else:
		prev_music += 1
		if prev_music > num_of_mus:
			prev_music = 1
		i = prev_music
	match i:
		1:
			music_player.stream = load("res://Music/Piranha 02.mp3")
		2:
			music_player.stream = load("res://Music/PPK_-_Voskreshenie_20718.mp3")
		3:
			music_player.stream = load("res://Music/Piranha 01.mp3")
		4:
			music_player.stream = load("res://Music/Alex Draym & Scott James - Terminal (Ataman Live Remix).mp3")
		5:
			music_player.stream = load("res://Music/Yakov - Toxic.mp3")
	music_player.play()


func check_last_asteroid():
	var ast = get_tree().get_nodes_in_group("Asteroids")
	if ast.size() == 0:
		ship.reset_state = true
		set_pause_mode(true)
		level += 1
		shop.update_state()
		shop.show()


func _on_AsteroidBombPlayer_finished():
	check_last_asteroid()


func start_level():
	for s in get_tree().get_nodes_in_group("Shots"):
		s.queue_free()
	ui_start.show()
	ui.game_over_show("LEVEL %02d" % level)
	start_points.shuffle()
	
#	level = 13

	if level < 4:
		for i in range(level):
			add_asteroids(AsteroidSize.Large, 1, start_points[i].position, 0)
	elif level == 4:
		var u = UFO.instance()
		add_child(u)
	elif level < 7:
		for i in range(3):
			if level > 3 + i:
				add_asteroids(AsteroidSize.Large, 1, start_points[i].position, 1)
			else:
				add_asteroids(AsteroidSize.Large, 1, start_points[i].position, 0)
	elif level < 10:
		for i in range(3):
			if level > 6 + i:
				add_asteroids(AsteroidSize.Large, 1, start_points[i].position, 2)
			else:
				add_asteroids(AsteroidSize.Large, 1, start_points[i].position, 1)
	elif level < 13:
		for i in range(3):
			if level > 9 + i:
				add_asteroids(AsteroidSize.Large, 1, start_points[i].position, 3)
			else:
				add_asteroids(AsteroidSize.Large, 1, start_points[i].position, 2)


func _on_Start_pressed():
	shop.hide()
	start_level()


func update_ui_shop(crminus):
	var cr = ui.credits - crminus
	ui.set_credits(cr)
	shop.update_state()


func _on_HPplus_pressed():
	ship.add_hp(100)
	update_ui_shop(2000) #


func _on_MaxHPplus_pressed():
	ship.add_max_hp(200)
	update_ui_shop(20000) #


func _on_SpeedPlus_pressed():
	ship.add_speed(50)
	update_ui_shop(5000)


func _on_RotationPLus_pressed():
	ship.add_rotation_speed(500)
	update_ui_shop(7000)


func _on_ShotSpeedPlus_pressed():
	ship.add_shot_speed()
	update_ui_shop(12000)


func _on_ShotPlus_pressed():
	ship.add_cannon()
	update_ui_shop(150000)
