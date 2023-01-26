extends "res://RB2D.gd"

class_name Asteroid


enum AsteroidSize {
	Small, Medium, Large
}


var size = AsteroidSize.Medium
var dmg = 0
var level = 0 setget set_level


func set_level(l):
	level = l
	if level == 1:
		get_node("AnimatedSprite").self_modulate = Color.coral #+
	elif level == 2:
		get_node("AnimatedSprite").self_modulate = Color.aquamarine #+
	elif level == 3:
#		get_node("AnimatedSprite").self_modulate = Color.yellow #+
		get_node("AnimatedSprite").self_modulate = Color(1, 1, 1, 10.0/255)
	elif level == 4:
		get_node("AnimatedSprite").self_modulate = Color.cyan #+
	elif level == 5:
		get_node("AnimatedSprite").self_modulate = Color.magenta #+
	elif level == 6:
		get_node("AnimatedSprite").self_modulate = Color.crimson #+


func _ready():
	randomize()
	linear_velocity = Vector2(randi()%300-150, randi()%300-150)
	angular_velocity = randf() * 2 - 1
	hp = hp * (1 + 0.5 * level)


func _on_RigidBody2D_body_entered(body):
	if body.name == "Spaceship":
		body.hit(dmg) #если астероид непрерывно толкает корабль, то он не получает дамаг :(
