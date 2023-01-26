extends MarginContainer


onready var game = get_node("../..")


func update_state():
	$VBoxContainer/GridContainer/HPplus.update_state(game.ui.credits, game.ship.hp, game.ship.maxhp)
	$VBoxContainer/GridContainer/MaxHPplus.update_state(game.ui.credits, game.ship.maxhp, -1)
	$VBoxContainer/GridContainer/SpeedPlus.update_state(game.ui.credits, game.ship.engine_thrust, -1)
	$VBoxContainer/GridContainer/RotationPLus.update_state(game.ui.credits, game.ship.spin_thrust, -1)
	var shot_speed = game.ship.reloadtime
	if game.ship.boostmode:
		shot_speed *= 2
	$VBoxContainer/GridContainer/ShotSpeedPlus.update_state(game.ui.credits,
		stepify(60/shot_speed, 0.01), -1)
	$VBoxContainer/GridContainer/ShotPlus.update_state(game.ui.credits, game.ship.number_cannon, -1)
