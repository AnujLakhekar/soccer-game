class_name PlayerStateRecovering
extends PlayerState

const duration_requrng  = 500

var time_start_req = Time.get_ticks_msec()

func _enter_tree() -> void:
	time_start_req = Time.get_ticks_msec()
	player.velocity = Vector2.ZERO
	animation.play("recover")
	
func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start_req > duration_requrng:
		transiction_state(Player.State.MOVING)
