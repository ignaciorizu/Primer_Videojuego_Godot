extends CharacterBody2D

const PATROL_SPEED: float = 100.0
const DIRECTION_LEFT: float = -1.0
const ANIMATION_WALK: String = "walk"

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _sensor_pivot: Marker2D = $SensorPivot
@onready var _wall_sensor: RayCast2D = $SensorPivot/WallSensor
@onready var _floor_sensor: RayCast2D = $SensorPivot/FloorSensor
@onready var _hitbox: Area2D = $Hitbox
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _current_direction: float = DIRECTION_LEFT

func _ready() -> void:
	_hitbox.body_entered.connect(_process_hitbox_collision)
	_animation_player.play(ANIMATION_WALK)

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_validate_patrol_path()
	_apply_movement()
	
	move_and_slide()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _validate_patrol_path() -> void:
	var has_hit_wall: bool = _wall_sensor.is_colliding()
	var has_floor_ended: bool = not _floor_sensor.is_colliding()
	var needs_inversion: bool = has_hit_wall or has_floor_ended
	
	var action_map: Dictionary = {
		true: _invert_direction,
		false: _ignore_action
	}
	
	var action: Callable = action_map[needs_inversion]
	action.call()

func _invert_direction() -> void:
	_current_direction *= -1.0
	_sprite.flip_h = _current_direction > 0.0
	_sensor_pivot.scale.x = -_current_direction
	
func _apply_movement() -> void:
	velocity.x = _current_direction * PATROL_SPEED

func _process_hitbox_collision(body: Node2D) -> void:
	var is_valid_player: bool = body != null and body.is_in_group("jugador")
	
	var collision_action_map: Dictionary = {
		true: _execute_damage_sequence,
		false: _ignore_action
	}
	
	var action: Callable = collision_action_map[is_valid_player]
	action.call_deferred()

func _execute_damage_sequence() -> void:
	var tree_state_map: Dictionary = {
		true: _apply_damage_and_reload,
		false: _ignore_action
	}
	
	var is_valid_tree: bool = is_inside_tree()
	var action: Callable = tree_state_map[is_valid_tree]
	action.call()

func _apply_damage_and_reload() -> void:
	world.subtract_life()
	get_tree().reload_current_scene()

func _ignore_action() -> void:
	pass
