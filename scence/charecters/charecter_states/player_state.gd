class_name PlayerState
extends Node

signal state_transiction_request(new_state: Player.State, state_data : PlayerStateData)


var player : Player = null
var animation : AnimationPlayer = null
var state_data : PlayerStateData = PlayerStateData.new()
var ball : Ball = null

func setup(context: Player, context_state_data : PlayerStateData, contect_animation: AnimationPlayer, contxt_ball: Ball) -> void:
	player = context
	animation = contect_animation
	state_data = context_state_data
	ball = contxt_ball



func on_animation_complete() -> void:
	pass

func transiction_state(state: Player.State, state_data : PlayerStateData = PlayerStateData.new()) -> void:
	state_transiction_request.emit(state, state_data)
	
