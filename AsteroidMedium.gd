extends Asteroid


const dmgMedium = 50
const hpMedium = 100
const crMedium = 1000
const mediumboom = preload("res://LargeBoom.tscn")


func _ready():
	connect("body_entered", self, "_on_RigidBody2D_body_entered")
	size = AsteroidSize.Medium
	sprite_size = Vector2(90, 90)
	hp = hpMedium
	dmg = dmgMedium
	._ready()


func die():
	var mb = mediumboom.instance()
	mb.position = position
	mb.scale = Vector2(0.66, 0.66)
	parent.add_child(mb)
	mb.play()
	parent.add_credits(crMedium)
	parent.add_asteroids(AsteroidSize.Small, 3, position, level)
	.die()
