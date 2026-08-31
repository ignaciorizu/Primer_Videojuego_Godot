extends Area2D

const GROUP_PLAYER: String = "jugador"

func _ready() -> void:
	body_entered.connect(_process_checkpoint_activation)

func _process_checkpoint_activation(body: Node2D) -> void:
	var is_valid_player: bool = body != null and body.is_in_group(GROUP_PLAYER)
	
	var activation_map: Dictionary = {
		true: _register_checkpoint,
		false: _ignore_collision
	}
	
	var action: Callable = activation_map[is_valid_player]
	action.call()

func _register_checkpoint() -> void:
	GameState.update_checkpoint_position(global_position)

func _ignore_collision() -> void:
	pass
