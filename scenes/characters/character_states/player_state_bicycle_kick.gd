class_name PlayerStateBicycleKick
extends PlayerState


const BONUS = 2.0

func _enter_tree() -> void:
	animation_player.play("bicycle_kick")
	ball_detection_area.body_entered.connect(_on_ball_entered)


func _on_ball_entered(ball : Ball) -> void:
	if ball.can_air_connect(5.0, 25.0):
		var destination = target_goal.get_radom_vector_position()
		var direction = ball.position.direction_to(destination)
		ball.shoot(direction * player.power * BONUS)


func on_animation_complete() -> void:
	transition_state(Player.State.RECOVERING)
