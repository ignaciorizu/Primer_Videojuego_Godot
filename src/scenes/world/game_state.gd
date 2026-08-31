extends Node

const MAX_LIVES: int = 3
const GAME_OVER_SCENE_PATH: String = "res://src/scenes/world/gameOver.tscn"

var _current_checkpoint_position: Vector2 = Vector2.ZERO
var _current_lives: int = MAX_LIVES
var _collected_items_registry: Dictionary = {}
var _has_intro_played: bool = false

signal lives_changed(new_lives_count: int)
signal checkpoint_updated

func is_intro_played() -> bool:
	return _has_intro_played

func register_intro_played() -> void:
	_has_intro_played = true

func update_checkpoint_position(new_position: Vector2) -> void:
	if new_position == Vector2.ZERO:
		push_error("Error de validacion: Checkpoint nulo.")
		return
	_current_checkpoint_position = new_position
	checkpoint_updated.emit()

func get_respawn_position() -> Vector2:
	return _current_checkpoint_position

func subtract_life() -> void:
	_current_lives -= 1
	lives_changed.emit(_current_lives)
	
	var action: Callable = { true: _execute_game_over, false: _continue_game }[_current_lives <= 0]
	action.call()

func _execute_game_over() -> void:
	_reset_data()
	var scene_resource: PackedScene = load(GAME_OVER_SCENE_PATH)
	get_tree().change_scene_to_packed.call_deferred(scene_resource)

func _continue_game() -> void:
	pass

func _reset_data() -> void:
	_current_lives = MAX_LIVES
	_current_checkpoint_position = Vector2.ZERO
	_collected_items_registry.clear()

func get_current_lives() -> int:
	return _current_lives

func is_item_collected(item_id: String) -> bool:
	return _collected_items_registry.has(item_id)

func register_collected_item(item_id: String) -> void:
	_collected_items_registry[item_id] = true

func restore_life() -> bool:
	var can_heal: bool = _current_lives < MAX_LIVES
	var action: Callable = { true: _add_life, false: _reject_heal }[can_heal]
	return action.call()

func _add_life() -> bool:
	_current_lives += 1
	lives_changed.emit(_current_lives)
	return true

func _reject_heal() -> bool:
	return false
	
