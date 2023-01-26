extends AnimatedSprite


func _on_LargeBoom_animation_finished():
	queue_free()
