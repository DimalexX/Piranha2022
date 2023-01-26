extends KinematicBody2D


const ufo_shot = preload("res://UFOShot.tscn")
const largeboom = preload("res://LargeBoom.tscn")
const shot_speed = 400 #скорость снаряда
const crShot = 100
const credits = 15000
const min_range = 350
const max_range = 450

onready var parent = get_parent()
onready var aniplayer = $AnimationPlayer
onready var tween = $Tween

var hp = 500


func _ready():
	randomize()
	aniplayer.play("jumpend")
	tween.interpolate_property(self, "position",
		Vector2(683, 0), Vector2(683, 200), 1.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Timer_timeout():
	aniplayer.play("jump")


func teleport():
	var ship_position = parent.ship.position
	if ship_position.x < 683:
		if ship_position.y < 384: #сектор 1
			move_to_pos(ship_position, 10, 60)
		else: #сектор 3
			move_to_pos(ship_position, -60, -10)
	else:
		if ship_position.y < 384: #сектор 2
			move_to_pos(ship_position, 120, 170)
		else: #сектор 4
			move_to_pos(ship_position, -170, -120)


func move_to_pos(s_p, ang1: float, ang2: float):
	aniplayer.play("jumpend")
	var v = Vector2.RIGHT * rand_range(min_range, max_range)
	position = s_p + v.rotated(rand_range(deg2rad(ang1), deg2rad(ang2)))#  ang1*PI/180, ang2*PI/180))


func do_shot():
	var us = ufo_shot.instance()
	var v: Vector2 = (parent.ship.position - position).normalized()
	us.linear_velocity = v * shot_speed
	us.position = position
	us.rotation = v.angle() + PI/2
	parent.add_child(us)
	var us2 = us.duplicate()
	us2.position = us.position + (Vector2.RIGHT * 30).rotated(us.rotation)
	parent.add_child(us2)
	us2 = us.duplicate()
	us2.position = us.position - (Vector2.RIGHT * 30).rotated(us.rotation)
	parent.add_child(us2)
	$ShotPlayer.play()


func hit(dmg):
	if hp > 0:
		hp -= dmg
		parent.add_credits(crShot)
		if hp <= 0:
			die()


func die():
	var lb = largeboom.instance()
	lb.position = position
	lb.scale = Vector2(1, 1)
	parent.add_child(lb)
	lb.play()
	parent.get_node("AsteroidBombPlayer").play()
	parent.add_credits(credits)
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "jump":
		teleport()
		do_shot()

