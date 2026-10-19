class_name GameState
extends Node

signal state_transition_signal(state : GameManager.State, data : GameStateData)

var state_data : GameStateData = null
func setup(context_state_data : GameStateData) -> void:
	state_data = context_state_data

func transition_state(state : GameManager.State, data : GameStateData = GameStateData.build()) -> void:
	state_transition_signal.emit(state, data)
