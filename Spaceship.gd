extends "res://RB2D.gd"


const crBoost = 3000
const dmgBomb = 40
const hpBoost = 300

var engine_thrust = 300 #ускорение двигателя 300 damp 1 лучшее 800 damp 1.5
var spin_thrust = 2000 #ускорение поворота 2000 damp 1.2 лучшее 7000 damp 2.2
const shot_speed = 600 #скорость снаряда
const Shot = preload("res://Shot.tscn") #сцена снаряда

const ship_start_position = Vector2(683, 650)

var maxhp = 1000
var number_cannon = 1
var reloadtime: float = 24 #frames время перезарядки
var thrust = Vector2() #вектор ускорения корабля
var rotation_dir = 0 #направление вращения
var reloadtimer = 0 #время с прошлого выстрела
var boostmode = false
var reset_state = false
var is_paused = true


func _ready():
	hp = maxhp
	ui.max_hp = maxhp
	ui.cur_hp = maxhp
	ui.credits = 0
	sprite_size = Vector2(70, 70)
	linear_damp


func _process(_delta):
	if is_paused:
		return
	if Input.is_action_just_pressed("reset_ship"):
		reset_state = true
	if Input.is_action_just_pressed("ui_up"):
		$EnginePlayer.play()
	if Input.is_action_pressed("ui_up"):
		thrust = Vector2(0, -engine_thrust)
		$Flame1.show()
		$Flame2.show()
	else:
		thrust = Vector2.ZERO
		$Flame1.hide()
		$Flame2.hide()
		$EnginePlayer.stop()
	rotation_dir = 0
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_select") and reloadtimer <= 0:
		do_shot()
		reloadtimer = reloadtime
	else:
		reloadtimer -= 1


func do_shot():
	var s1 = Shot.instance()
	var s2
	s1.position = position + Vector2(0, -50).rotated(rotation)
	s1.rotation = rotation
	s1.linear_velocity = Vector2(0, -shot_speed).rotated(rotation)
	parent.add_child(s1)
	if number_cannon >= 2:
		s2 = s1.duplicate()
		s1.position = s1.position + Vector2(-10, 0).rotated(rotation)
		s2.position = s2.position + Vector2(10, 0).rotated(rotation)
		parent.add_child(s2)
	if number_cannon == 3:
		var s3 = s1.duplicate()
		s3.position = s3.position + Vector2(10, 0).rotated(rotation)
		parent.add_child(s3)
		s1.linear_velocity = s1.linear_velocity.rotated(-0.17)
		s1.rotation_degrees = s1.rotation_degrees - 10
		s2.linear_velocity = s2.linear_velocity.rotated(0.17)
		s2.rotation_degrees = s2.rotation_degrees + 10
	$ShotPlayer.play()


func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, ship_start_position)
		linear_velocity *= 0
		angular_velocity *= 0
		reset_state = false
	else:
		applied_force = thrust.rotated(rotation)
		applied_torque = rotation_dir * spin_thrust
		._integrate_forces(state) #вызов наследуемой функции


func hit(dmg):
	$HitPlayer.play()
	ui.cur_hp = hp - dmg
	.hit(dmg)


func die():
	parent.get_node("GameOverPlayer").play()
	.die()


func add_hp(hpplus):
	hp += hpplus
	if hp > maxhp:
		hp = maxhp
	ui.cur_hp = hp


func add_max_hp(maxhpplus):
	maxhp += maxhpplus
	ui.max_hp = maxhp
#	add_hp(maxhpplus)


func add_speed(speedplus):
	engine_thrust += speedplus
	linear_damp += .05


func add_rotation_speed(rotationspeedplus):
	spin_thrust += rotationspeedplus
	angular_damp += .1


func add_shot_speed():
	if boostmode:
		reloadtime -= 0.5
	else:
		reloadtime -= 1


func add_cannon():
	number_cannon += 1


func get_boost(boost_name):
	if boost_name == "Credit":
		parent.add_credits(crBoost)
	elif boost_name == "Bomb":
		$BombBombPlayer.play()
		parent.get_node("BoomAnimator").play("BOOOOM!!!!")
		var ast = get_tree().get_nodes_in_group("Asteroids")
		for a in ast:
			a.hit(dmgBomb) #hp маленького астероида
	elif boost_name == "HPplus":
		add_hp(hpBoost)
	elif boost_name == "Boost":
		if boostmode:
			$BoostTimer.start()
		else:
			boostmode = true
			$BoostTimer.start()
			reloadtime = reloadtime / 2
	if boost_name != "Bomb":
		$BoostPlayer.play()


func _on_Timer_timeout():
	boostmode = false
	reloadtime = reloadtime * 2
