extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -500.0
const BUBBLE_PRE_DELAY: float = 1.0
const CAMERA_PAN_DURATION: float = 1.5
const CAMERA_REST_DURATION: float = 0.5

const STATE_IDLE: String = "idle"
const STATE_WALK: String = "walk"
const STATE_JUMP: String = "jump"

const ANIMATION_MAP: Dictionary = {
	STATE_IDLE: "idle",
	STATE_WALK: "walk",
	STATE_JUMP: "jump"
}

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _jump_sprite: Sprite2D = $JumpSprite
@onready var _camera: Camera2D = $Camera2D
@onready var _objective_bubble: Node2D = $Objetivo

var _current_state: String = STATE_IDLE
var _previous_state: String = ""
var _is_input_locked: bool = false

func _ready() -> void:
	_objective_bubble.visible = false
	_initialize_spawn_position()

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	var process_action_map: Dictionary = {
		true: _process_locked_state,
		false: _process_unlocked_state
	}
	
	var action: Callable = process_action_map[_is_input_locked]
	action.call()
	
	_update_logical_state()
	_apply_visual_state(velocity.x)
	move_and_slide()

func _process_locked_state() -> void:
	_apply_movement(0.0)

func _process_unlocked_state() -> void:
	_handle_jump()
	var direction: float = Input.get_axis("ui_left", "ui_right")
	_apply_movement(direction)

func display_objective_temporarily() -> void:
	_objective_bubble.visible = true
	var timer_tween: Tween = get_tree().create_tween()
	timer_tween.tween_interval(BUBBLE_PRE_DELAY)
	timer_tween.finished.connect(_hide_objective_bubble)

func execute_intro_sequence(target_global_pos: Vector2) -> void:
	_is_input_locked = true
	_objective_bubble.visible = true
	
	var sequence_tween: Tween = get_tree().create_tween()
	var original_camera_pos: Vector2 = _camera.global_position
	
	sequence_tween.tween_interval(BUBBLE_PRE_DELAY)
	sequence_tween.tween_property(_camera, "global_position", target_global_pos, CAMERA_PAN_DURATION).set_trans(Tween.TRANS_SINE)
	sequence_tween.tween_interval(CAMERA_REST_DURATION)
	sequence_tween.tween_property(_camera, "global_position", original_camera_pos, CAMERA_PAN_DURATION).set_trans(Tween.TRANS_QUAD)
	
	sequence_tween.finished.connect(_finalize_intro_sequence)

func _finalize_intro_sequence() -> void:
	_hide_objective_bubble()
	_camera.position = Vector2.ZERO
	_is_input_locked = false

func _hide_objective_bubble() -> void:
	_objective_bubble.visible = false

func _initialize_spawn_position() -> void:
	var world_node: Node = get_parent()
	if world_node.has_method("get_respawn_position"):
		var respawn_pos: Vector2 = world_node.get_respawn_position()
		if respawn_pos != Vector2.ZERO:
			global_position = respawn_pos

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _apply_movement(direction: float) -> void:
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

func _update_logical_state() -> void:
	_previous_state = _current_state
	
	var is_in_air: bool = not is_on_floor()
	var is_moving: bool = velocity.x != 0.0

	var ground_state_map: Dictionary = {
		true: STATE_WALK,
		false: STATE_IDLE
	}
	
	var air_state_map: Dictionary = {
		true: STATE_JUMP,
		false: ground_state_map[is_moving]
	}
	
	_current_state = air_state_map[is_in_air]

func _apply_visual_state(direction: float) -> void:
	_update_sprite_direction(direction)
	
	if _current_state != _previous_state:
		_toggle_active_sprite(_current_state)
		_play_animation_state(_current_state)

func _update_sprite_direction(direction: float) -> void:
	if direction == 0.0:
		return
		
	var is_facing_left: bool = direction > 0.0
	_sprite.flip_h = is_facing_left
	_jump_sprite.flip_h = is_facing_left

func _toggle_active_sprite(state: String) -> void:
	var sprite_visibility_map: Dictionary = {
		STATE_IDLE: true,
		STATE_WALK: true,
		STATE_JUMP: false
	}
	
	var is_sheet_active: bool = sprite_visibility_map.get(state, true)
	
	_sprite.visible = is_sheet_active
	_jump_sprite.visible = not is_sheet_active

func _play_animation_state(state: String) -> void:
	if state == STATE_WALK:
		_animation_player.play(ANIMATION_MAP[state])
	else:
		_animation_player.stop()
