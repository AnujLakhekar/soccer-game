class_name PlayerStatePreparingShoot
extends PlayerState

const Durational_max_bonus = 1000.0

var shot_direction = Vector2.ZERO
var time_start_shot = Time.get_ticks_msec()

func _enter_tree() -> void:
	animation.play("prep_kick")
	player.velocity = Vector2.ZERO

func _process(delta: float) -> void:
	shot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta
	if KeyUtils.is_action_just_released(player.control_scheme, KeyUtils.Action.SHOOT):
		var duration_presssed = clamp(Time.get_ticks_msec() - time_start_shot, 0.0, Durational_max_bonus)
		var ease_time = duration_presssed / Durational_max_bonus
		var bonus = ease(ease_time, 2.0)
		var shot_power = player.power * (1 + bonus)
		shot_direction = shot_direction.normalized() 
		var state_data = PlayerStateData.build().set_shor_power(shot_power).set_shot_direction(shot_direction)
		transiction_state(Player.State.SHOOTING, state_data)
		
		
