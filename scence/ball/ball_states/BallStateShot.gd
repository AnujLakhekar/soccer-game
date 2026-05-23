class_name BallStateShot
extends BallState

const DURATION_SHOT = 1000
const SHOT_HEIGHT = 5
const SHOT_SCALE = 0.8

var time_shoot_start = Time.get_ticks_msec()


func _enter_tree() -> void:
	if ball.velocity.x >= 0:
		animation.play("roll")
		animation.advance(0)
	else:
		animation.play_backwards("roll")
		animation.advance(0)
	sprite.scale.y = SHOT_SCALE
	ball.height = SHOT_HEIGHT


func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_shoot_start >DURATION_SHOT:
		ball.height = 0.0
		sprite.scale.y = 1
		animation.play("idle")
		state_transition_requested.emit(Ball.State.FREEFORM)
	else:
		ball.move_and_collide(ball.velocity * delta)
	
	
func _exit_tree() -> void:
	sprite.scale.y = 1.0
