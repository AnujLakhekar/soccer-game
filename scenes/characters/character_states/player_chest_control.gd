class_name PlayerStateChestControl
extends PlayerState

const DURATION = 600
var time_start = Time.get_ticks_msec()


func _enter_tree() -> void:
	animation_player.play("chest_controll")
	player.velocity = Vector2.ZERO
	time_start = Time.get_ticks_msec()
	
func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start > DURATION:
		exit()

func can_pass() -> bool:
	return true

func exit() -> void:
	transition_state(Player.State.MOVING)
