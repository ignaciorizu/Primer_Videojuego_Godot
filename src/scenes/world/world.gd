extends Node

const MAX_LIVES: int = 3

var current_checkpoint_position: Vector2 = Vector2.ZERO
var current_lives: int = MAX_LIVES
var collected_items_registry: Dictionary = {}

signal lives_changed(new_lives_count: int)

func _ready() -> void:
	pass

func update_checkpoint_position(new_position: Vector2) -> void:
	if new_position == Vector2.ZERO:
		push_error("Error de validacion: Intento de guardar un checkpoint nulo.")
		return
		
	current_checkpoint_position = new_position

func get_respawn_position() -> Vector2:
	if current_checkpoint_position == Vector2.ZERO:
		push_warning("Advertencia: No hay checkpoint registrado. Retornando origen.")
		
	return current_checkpoint_position

func restore_life() -> bool:
	var can_heal: bool = current_lives < MAX_LIVES
	
	var heal_action_map: Dictionary = {
		true: _add_life,
		false: _reject_heal
	}
	
	var action: Callable = heal_action_map[can_heal]
	return action.call()

func _add_life() -> bool:
	current_lives += 1
	lives_changed.emit(current_lives)
	return true

func _reject_heal() -> bool:
	return false

func subtract_life() -> void:
	current_lives -= 1
	lives_changed.emit(current_lives)
	
	if current_lives <= 0:
		_reset_game_state()

func register_collected_item(item_id: String) -> void:
	collected_items_registry[item_id] = true

func is_item_collected(item_id: String) -> bool:
	return collected_items_registry.has(item_id)

func _reset_game_state() -> void:
	current_lives = MAX_LIVES
	current_checkpoint_position = Vector2.ZERO
	collected_items_registry.clear()
