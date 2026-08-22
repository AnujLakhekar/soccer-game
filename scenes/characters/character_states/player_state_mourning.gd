class_name PlayerStateMouring
extends PlayerState


func _enter_tree() -> void:
	animation_player.play("mourn")
	player.velocity = Vector2.ZERO
