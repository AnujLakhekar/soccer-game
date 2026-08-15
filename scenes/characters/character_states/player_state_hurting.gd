class_name PlayerStateHurting
extends PlayerState

const DURATION = 1000
const AIR = 35.0
const HURT_HEIGHT_VELOCITY = 0.3
const TUMBLE_SPPED = 100

var get_scence_time = Time.get_ticks_msec()

func _enter_tree() -> void:
	animation_player.play("hurt")
	get_scence_time = Time.get_ticks_msec()
	player.height_velocity = HURT_HEIGHT_VELOCITY
	if ball.carrier == player:
		ball.tumble(state_data.hurt_direction * TUMBLE_SPPED)

func  _process(delta: float) -> void:
	if Time.get_ticks_msec() - get_scence_time > DURATION:
		transition_state(Player.State.RECOVERING)
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR)
