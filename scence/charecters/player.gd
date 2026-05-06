class_name Player
extends CharacterBody2D

enum ControlScheme {CPU,P1,P2}
enum State {MOVING, TACKLE}


@export var control_scheme : ControlScheme
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = %playerSprite
@export var speed: float 

var current_state : PlayerState = null
var factory = PlayerStateFactory.new()
var heading = Vector2.RIGHT


func _ready() -> void:
	switch_state(State.MOVING)

func _process(delta: float) -> void:
	flip_sprite()
	move_and_slide()
	
func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = factory.get_fresh_state(state)
	current_state.setup(self, animation)
	current_state.state_transiction_request.connect(switch_state.bind())
	current_state.name = "playerStateMachine" + str(state)
	call_deferred("add_child", current_state)
	
func handle_movement_animation() -> void:
	if velocity.length() > 0:
		animation.play("run")
	else:
		animation.play("idle")
		
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
