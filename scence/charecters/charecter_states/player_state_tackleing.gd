class_name PlayerStateTackle
extends PlayerState

const TACKLE_DURATION = 200
var tackle_start_time = Time.get_ticks_msec()


func _enter_tree() -> void:
	animation.play("tackel")
	

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - tackle_start_time > TACKLE_DURATION:
		state_transiction_request.emit(Player.State.RECOVERING)
		
