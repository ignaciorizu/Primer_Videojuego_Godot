extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -500.0

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

var _current_state: String = STATE_IDLE
var _previous_state: String = ""

func _ready() -> void:
	_initialize_spawn_position()

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	
	var direction: float = Input.get_axis("ui_left", "ui_right")
	_apply_movement(direction)
	
	_update_logical_state()
	_apply_visual_state(direction)
	
	move_and_slide()

func _initialize_spawn_position() -> void:
	var respawn_pos: Vector2 = world.get_respawn_position()
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
