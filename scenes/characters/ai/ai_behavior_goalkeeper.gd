class_name AiBehaviorGolie
extends AIbehavior


const PROXIMITY_VALUE = 10.0


func perform_ai_movements() -> void:
	var total_steering_Force := get_goalie_sterring_force()
	
	
	total_steering_Force = total_steering_Force.limit_length(1.0)
	player.velocity = total_steering_Force * player.speed


func perform_ai_desition() -> void:
	if ball.is_heading_for_scoring_area(player.own_goal.get_scoring_area()):
		player.switch_state(Player.State.DIVING)

func get_goalie_sterring_force() -> Vector2:
	var top = player.own_goal.get_top_target_position()
	var bottom = player.own_goal.get_bottom_target_position()
	var center = player.spawn_point
	var target_y = clamp(ball.position.y, top.y, bottom.y)
	var destination = Vector2(center.x, target_y)
	var direction = player.position.direction_to(destination)
	var distance_to_destination = player.position.distance_to(destination)
	var weight = clampf(distance_to_destination / PROXIMITY_VALUE, 0, 1) 
	return weight * direction
