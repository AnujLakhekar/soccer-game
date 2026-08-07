class_name AIbehavior
extends Node


var AI_TICK_TIME = 200

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
	total_steering_Force += get_weight_streeing_force()
	total_steering_Force = total_steering_Force.limit_length(1.0)
	player.velocity = total_steering_Force * player.speed

func perform_ai_desition() -> void:
	pass

func get_weight_streeing_force() -> Vector2:
	print(player.weight_on_duty_sterrring)
	return player.weight_on_duty_sterrring * player.position.direction_to(ball.position)
