extends Asteroid


const dmgSmall = 25
const hpSmall = 50
const crSmall = 500
const smallboom = preload("res://LargeBoom.tscn")


func _ready():
	connect("body_entered", self, "_on_RigidBody2D_body_entered")
	size = AsteroidSize.Small
	sprite_size = Vector2(66, 66)
	hp = hpSmall
	dmg = dmgSmall
	._ready()


func die():
	var sb = smallboom.instance()
	sb.position = position
	sb.scale = Vector2(0.4, 0.4)
	parent.add_child(sb)
	sb.play()
	parent.add_credits(crSmall)
	.die()
