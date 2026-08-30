extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -500.0

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	_initialize_spawn_position()

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	
	var direction: float = Input.get_axis("ui_left", "ui_right")
	_apply_movement(direction)
	_update_visual_state(direction)
	
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
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _update_visual_state(direction: float) -> void:
	if direction != 0.0:
		_sprite.flip_h = direction > 0.0
		_animation_player.play("walk")
	else:
		_animation_player.stop()
