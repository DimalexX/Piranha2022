extends Asteroid


const dmgLarge = 100
const hpLarge = 200
const crLarge = 2000
const largeboom = preload("res://LargeBoom.tscn")


func _ready():
	connect("body_entered", self, "_on_RigidBody2D_body_entered")
	size = AsteroidSize.Large
	sprite_size = Vector2(140, 140)
	hp = hpLarge
	dmg = dmgLarge
	._ready()


func die():
	var lb = largeboom.instance()
	lb.position = position
	lb.scale = Vector2(1, 1)
	parent.add_child(lb)
	lb.play()
	parent.add_credits(crLarge)
	parent.add_asteroids(AsteroidSize.Medium, 3, position, level)
	.die()
