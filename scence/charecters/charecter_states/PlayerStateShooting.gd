class_name PlayerStateShoot
extends PlayerState


func _enter_tree() -> void:
	animation.play("kick")


func on_animation_complete() -> void:
	if player.control_scheme == player.ControlScheme.CPU:
		transiction_state(Player.State.RECOVERING)
	else: 
		transiction_state(Player.State.MOVING)
	Shoot()
		
	
func Shoot() ->  void:
	ball.shoot(state_data.shot_direction * state_data.shot_power)
