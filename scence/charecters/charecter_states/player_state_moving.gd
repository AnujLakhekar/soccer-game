class_name  PlayerStateMoving
extends PlayerState


func _process(delta: float) -> void:
	if player.control_scheme == player.ControlScheme.CPU:
		pass
	else:
		handle_human_movement()
	
	player.set_Heading()
	player.handle_movement_animation()

func handle_human_movement() -> void:
	var direction = KeyUtils.get_input_vector(player.control_scheme);
	player.velocity = direction * player.speed;
	
	if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		state_transiction_request.emit(Player.State.TACKLE)
