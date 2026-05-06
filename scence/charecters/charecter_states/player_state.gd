class_name PlayerState
extends Node

signal state_transiction_request(new_state: Player.State)


var player : Player = null
var animation : AnimationPlayer = null


func setup(context: Player, contect_animation: AnimationPlayer) -> void:
	player = context
	animation = contect_animation
