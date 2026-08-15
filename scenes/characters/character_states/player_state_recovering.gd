class_name PlayerStateRecovering
extends PlayerState

const DURATION_RECOVERY := 500
var time_start_recovery := Time.get_ticks_msec()

func _enter_tree() -> void:
	time_start_recovery = Time.get_ticks_msec()
	player.velocity = Vector2.ZERO
	animation_player.play("recover")
	#var ball_direction = player.heading
	#var ball_velocity = ball_direction * player.speed
	#player.ball.shoot(ball_velocity)

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_recovery > DURATION_RECOVERY:
		transition_state(Player.State.MOVING)
