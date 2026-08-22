class_name AIbehavior
extends Node


const AI_TICK_TIME = 200


var ball : Ball = null
var player : Player = null
var ai_scenece_time = Time.get_ticks_msec()
var oppnent_detection_area : Area2D = null
var team_detection_area : Area2D = null

func _ready() -> void:
	ai_scenece_time = Time.get_ticks_msec() + randi_range(0, AI_TICK_TIME)
	
func setup(context_ball : Ball, context_player :  Player, oppnent_detection_area_context : Area2D, context_team_detection_area : Area2D) -> void:
	player = context_player
	ball = context_ball
	oppnent_detection_area = oppnent_detection_area_context
	team_detection_area = context_team_detection_area

func process_ai() -> void:
	if Time.get_ticks_msec() - ai_scenece_time > AI_TICK_TIME:
		ai_scenece_time = Time.get_ticks_msec()
		perform_ai_movements()
		perform_ai_desition()
	


func perform_ai_movements() -> void:
	pass

func perform_ai_desition() -> void:
	pass


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

func is_ball_posseded_by_opponent() -> bool:
	return ball.carrier != null and ball.carrier.country != player.country

func is_ball_carried_by_teammate() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.country == player.country

func has_oppoent_nearby() -> bool:
	var players = oppnent_detection_area.get_overlapping_bodies()
	return players.find_custom(func(p: Player): return p.country !=player.country) > -1
