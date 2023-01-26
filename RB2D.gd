extends RigidBody2D


const crShot = 100

onready var screen_size = get_viewport().get_visible_rect().size
onready var ui = $"../UI"
onready var parent = get_parent()

var sprite_size = Vector2(90, 90) #Medium size asteroid
var hp = 0


func _integrate_forces(state):
	var trans = state.transform
	if trans.origin.x < -sprite_size.x/2:
		trans.origin.x += screen_size.x + sprite_size.x
	elif trans.origin.x > screen_size.x + sprite_size.x/2:
		trans.origin.x -= screen_size.x + sprite_size.x
	if trans.origin.y < -sprite_size.y/2:
		trans.origin.y += screen_size.y + sprite_size.y
	elif trans.origin.y > screen_size.y + sprite_size.y/2:
		trans.origin.y -= screen_size.y + sprite_size.y
	state.transform = trans


func die():
	parent.get_node("AsteroidBombPlayer").play()
	queue_free()


func hit(dmg):
	if hp > 0:
		hp -= dmg
		if name != "Spaceship":
			parent.add_credits(crShot)
		if hp <= 0:
			die()


#func add_credits(c):
#	ui.credits = ui.credits + c
