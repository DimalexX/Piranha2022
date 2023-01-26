extends RigidBody2D

const dmgShipShot = 10
const boom = preload("res://Particles2D.tscn")
const screen_center = Vector2(1366/2, 768/2)
const check_time = 60 #frames

var check_screen_size = check_time
var dmgShot = dmgShipShot
onready var parent = get_parent()


func _process(_delta):
	check_screen_size -= 1
	if check_screen_size <= 0:
		check_screen_size = check_time
		if position.distance_to(screen_center) > 1000:
			queue_free()


func _on_Shot_body_entered(body):
	parent.get_node("BombPlayer").play()
	var b = boom.instance()
	b.position = position + Vector2(0, -11).rotated(rotation)
	parent.add_child(b)
	b.emitting = true
	body.hit(dmgShot)
	queue_free()
