class_name AIBehaviorFeild
extends AIbehavior

const SPRED_AI_FACTOR = 0.8
const SHOT_THRESHOLD = 150
const SHOT_PROBABILITY = 0.3
const TAKLE_PROBABILITY = 0.3
const TAKLE_DISTANCE = 15
const PASS_PROBABILITY = 0.05

func perform_ai_movements() -> void:
	var total_steering_Force := Vector2.ZERO
	if player.has_ball():
		total_steering_Force += get_carrier_sterring_force()
	elif is_ball_carried_by_teammate():
		total_steering_Force += get_assits_formation_steering()
	else:
		total_steering_Force += get_weight_streeing_force()
		if total_steering_Force.length_squared() < 1:
			if is_ball_posseded_by_opponent():
				total_steering_Force += get_spawn_steering_force()
			elif ball.carrier == null:
				total_steering_Force += get_ball_proximity_steering_force()
		
	total_steering_Force = total_steering_Force.limit_length(1.0)
	player.velocity = total_steering_Force * player.speed

func perform_ai_desition() -> void:
	
	if is_ball_posseded_by_opponent() and player.position.distance_to(ball.position) < TAKLE_DISTANCE and randf() < TAKLE_PROBABILITY:
		player.switch_state(Player.State.TACKLING)

	if ball.carrier == player:
		var target := player.target_goal.get_center_target_position()
		if  player.position.distance_to(target) < SHOT_THRESHOLD and randf() < SHOT_PROBABILITY:
			face_towrds_target_goal()
			var shot_direction = player.position.direction_to(player.target_goal.get_radom_vector_position())
			var data = PlayerStateData.build().set_shot_power(player.power).set_shot_direction(shot_direction)
			player.switch_state(Player.State.SHOOTING, data)
		elif randf() < PASS_PROBABILITY  and has_oppoent_nearby() and is_teamate_in_view():
			player.switch_state(Player.State.PASSING)


func get_weight_streeing_force() -> Vector2:
	return player.weight_on_duty_sterrring * player.position.direction_to(ball.position)

func get_assits_formation_steering() -> Vector2:
	var spawn_diffrence = ball.carrier.spawn_point - player.spawn_point
	var assists_distance = ball.carrier.position - spawn_diffrence * SPRED_AI_FACTOR
	var direction = player.position.direction_to(assists_distance)
	var weight = get_bicycle_weight(player.position, assists_distance, 30, 0.2, 60, 1)
	return weight * direction

func get_carrier_sterring_force() -> Vector2:
	var target = player.target_goal.get_center_target_position()
	var direction = player.position.direction_to(target)
	var weight = get_bicycle_weight(player.position, target, 100, 0, 150, 1)
	return weight * direction  


func get_ball_proximity_steering_force() -> Vector2:
	var weight = get_bicycle_weight(player.position, ball.position, 50, 1, 120, 0)
	var direction  = player.position.direction_to(ball.position)
	return weight * direction

func get_spawn_steering_force() -> Vector2:
	var weight = get_bicycle_weight(player.position, player.spawn_point, 30, 1, 100, 0)
	var direction = player.position.direction_to(player.spawn_point)
	return weight * direction

func is_teamate_in_view() -> bool:
	var player_in_view = team_detection_area.get_overlapping_bodies()
	return player_in_view.find_custom(func(p : Player): return p != player and p.country == player.country) > -1
