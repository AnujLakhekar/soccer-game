class_name Player
extends CharacterBody2D

enum ControlScheme {CPU,P1,P2}

@export var control_scheme : ControlScheme
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = %playerSprite
@export var speed: float 

var heading = Vector2.RIGHT

func _process(delta: float) -> void:
	if control_scheme == ControlScheme.CPU:
		pass
	else:
		handle_human_movement()
	
	set_Heading()
	flip_sprite()
	handle_movement_animation()
	move_and_slide()
	
func handle_movement_animation() -> void:
	if velocity.length() > 0:
		animation.play("run")
	else:
		animation.play("idle")
		

func handle_human_movement() -> void:
	var direction = KeyUtils.get_input_vector(control_scheme);
	velocity = direction * speed;

func set_Heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT
	
func flip_sprite() -> void:
	if heading == Vector2.RIGHT:
		sprite.flip_h = false
	elif heading == Vector2.LEFT:
		sprite.flip_h = true
