class_name PlayerStateTackle
extends PlayerState

const TACKLE_END_DURATION = 200
var tackle_start_time =  Time.get_ticks_msec()
var GROUND_FRICTION = 250.0
var is_tackle_completed = false

func _enter_tree() -> void:
	animation.play("tackel")

	

func _process(delta: float) -> void:
	if not is_tackle_completed:
		player.velocity.move_toward(Vector2.ZERO, delta * GROUND_FRICTION)
		if player.velocity == Vector2.ZERO:
			tackle_start_time =  Time.get_ticks_msec()
			
		
	if Time.get_ticks_msec() - tackle_start_time > TACKLE_END_DURATION:
		state_transiction_request.emit(Player.State.RECOVERING)
