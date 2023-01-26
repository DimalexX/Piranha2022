extends KinematicBody2D


const max_ship_speed = 300
const max_rotation_speed = 3


var ship_speed = 0
var ship_velocity = Vector2(0, 0)


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		ship_speed = max_ship_speed
		$Flame1.show()
		$Flame2.show()
	else:
		ship_speed = ship_speed * 0.97
		$Flame1.hide()
		$Flame2.hide()
	if Input.is_action_pressed("ui_left"):
		rotation -= max_rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += max_rotation_speed * delta
	var vel = -ship_speed * transform.y
	move_and_slide(vel)
