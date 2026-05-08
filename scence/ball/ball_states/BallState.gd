class_name BallState
extends Node

signal  state_transition_requested(state: Ball.State)

var ball : Ball = null
var carrier :Player = null
var player_detection_area :Area2D = null
var animation : AnimationPlayer

func setup(context: Ball, player_detection_area_cntexst: Area2D, context_carrier, animationContext: AnimationPlayer) -> void:
	ball = context
	carrier = context_carrier
	player_detection_area  = player_detection_area_cntexst
	animation = animationContext
