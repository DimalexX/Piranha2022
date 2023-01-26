extends CanvasLayer


func _on_Timer_timeout():
	queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select")\
		or event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		queue_free()
