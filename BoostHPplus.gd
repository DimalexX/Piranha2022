extends Area2D


func _on_BoostCredit_body_entered(body):
	body.get_boost("HPplus")
	queue_free()


func _on_Timer_timeout():
	queue_free()
