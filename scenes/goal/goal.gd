class_name Goal
extends Node2D

@onready var back_net_area := %BackNetArea
@onready var targets: Node2D = %targets
@onready var scoreing_area: Area2D = %ScoreingArea
var country = ""



func initialize(context_country : String) -> void:
	country = context_country

func _ready() -> void:
	back_net_area.body_entered.connect(on_ball_enter_back_net.bind())
	scoreing_area.body_entered.connect(on_ball_enter_scoring_area)

func on_ball_enter_back_net(ball: Ball) -> void:
	ball.stop()

func get_radom_vector_position() -> Vector2:
	return targets.get_child(randi_range(0, targets.get_child_count() - 1)).global_position

func on_ball_enter_scoring_area(_ball :Ball) -> void:
	GameEvents.team_scored.emit(country)

func get_center_target_position() -> Vector2:
	return targets.get_child(int(targets.get_child_count() / 2.0)).global_position

func get_top_target_position() -> Vector2:
	return targets.get_child(int(0)).global_position

func get_bottom_target_position() -> Vector2:
	return targets.get_child(int(targets.get_child_count() / 2.0)).global_position

func get_scoring_area() -> Area2D:
	return scoreing_area
