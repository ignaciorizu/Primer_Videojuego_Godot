extends Area2D

signal checkpoint_reached(spawn_position: Vector2)
var _is_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_reached.connect(world.update_checkpoint_position)

func _on_body_entered(body: Node2D) -> void:
	if not _is_active and body.is_in_group("jugador"):
		activate_checkpoint()

func activate_checkpoint() -> void:
	_is_active = true
	checkpoint_reached.emit(global_position)
