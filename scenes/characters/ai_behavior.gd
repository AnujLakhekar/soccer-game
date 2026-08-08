class_name AIbehavior
extends Node


const AI_TICK_TIME = 200
const SPRED_AI_FACTOR = 0.8
const SHOT_THRESHOLD = 150
const SHOT_PROBABILITY = 0.3

var ball : Ball = null
var player : Player = null
var ai_scenece_time = Time.get_ticks_msec()


func _ready() -> void:
	ai_scenece_time = Time.get_ticks_msec() + randi_range(0, AI_TICK_TIME)
	
func setup(context_ball : Ball, context_player :  Player) -> void:
	player = context_player
	ball = context_ball
	

func process_ai() -> void:
	if Time.get_ticks_msec() - ai_scenece_time > AI_TICK_TIME:
		ai_scenece_time = Time.get_ticks_msec()
		perform_ai_movements()
		perform_ai_desition()
	


func perform_ai_movements() -> void:
	var total_steering_Force := Vector2.ZERO
	if player.has_ball():
		total_steering_Force += get_carrier_sterring_force()
	elif player.role != Player.Role.GOALTE:
		total_steering_Force += get_weight_streeing_force()
		if is_ball_carried_by_teammate():
			total_steering_Force += get_assits_formation_steering()
			
	total_steering_Force = total_steering_Force.limit_length(1.0)
	player.velocity = total_steering_Force * player.speed

func perform_ai_desition() -> void:
	if ball.carrier == player:
		var target := player.target_goal.get_center_target_position()
		if  player.position.distance_to(target) < SHOT_THRESHOLD and randf() < SHOT_PROBABILITY:
			face_towrds_target_goal()
			var shot_direction = player.position.direction_to(player.target_goal.get_radom_vector_position())
			var data = PlayerStateData.build().set_shot_power(player.power).set_shot_direction(shot_direction)
			player.switch_state(Player.State.SHOOTING, data)
		
			

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

func get_bicycle_weight(position: Vector2, center_target: Vector2, inner_circle_radius : float, inner_circle_weight : float, outer_circle_radius : float, outer_circle_weight : float) -> float:
	var distance_to_center = position.distance_to(center_target)
	if distance_to_center > outer_circle_radius:
		return outer_circle_weight
	elif distance_to_center < inner_circle_radius:
		return inner_circle_weight
	else:
		var distance_to_inner_radius = distance_to_center - inner_circle_radius
		var close_range_distance = outer_circle_radius - inner_circle_radius
		return lerpf(inner_circle_weight, outer_circle_weight, distance_to_inner_radius / close_range_distance)

func face_towrds_target_goal() -> void:
	if not player.is_facing_target_goal():
		player.heading = player.heading * -1

func is_ball_carried_by_teammate() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.country == player.country
