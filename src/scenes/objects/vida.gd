extends Area2D

@export var unique_item_id: String = ""

func _ready() -> void:
	_validate_initial_state()
	body_entered.connect(_process_collection)

func _validate_initial_state() -> void:
	var is_already_collected: bool = GameState.is_item_collected(unique_item_id)
	
	var state_action_map: Dictionary = {
		true: queue_free,
		false: _ignore_action
	}
	
	var action: Callable = state_action_map[is_already_collected]
	action.call()

func _process_collection(body: Node2D) -> void:
	var is_valid_player: bool = body != null and body.is_in_group("jugador")

	var collection_action_map: Dictionary = {
		true: _execute_collection_sequence,
		false: _ignore_action
	}

	var action: Callable = collection_action_map[is_valid_player]
	action.call_deferred()

func _execute_collection_sequence() -> void:
	var tree_state_map: Dictionary = {
		true: _apply_heal_and_register,
		false: _ignore_action
	}

	var is_valid_tree: bool = is_inside_tree()
	var action: Callable = tree_state_map[is_valid_tree]
	action.call()

func _apply_heal_and_register() -> void:
	var was_healed: bool = GameState.restore_life()

	var registration_map: Dictionary = {
		true: _finalize_collection,
		false: _ignore_action
	}

	var action: Callable = registration_map[was_healed]
	action.call()

func _finalize_collection() -> void:
	GameState.register_collected_item(unique_item_id)
	queue_free()

func _ignore_action() -> void:
	pass
