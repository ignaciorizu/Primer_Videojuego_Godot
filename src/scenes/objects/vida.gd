extends Area2D

func _ready() -> void:
	body_entered.connect(_process_collection)

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
		true: _apply_heal_and_destroy,
		false: _ignore_action
	}

	var is_valid_tree: bool = is_inside_tree()
	var action: Callable = tree_state_map[is_valid_tree]
	action.call()

func _apply_heal_and_destroy() -> void:
	world.restore_life()
	queue_free()

func _ignore_action() -> void:
	pass
