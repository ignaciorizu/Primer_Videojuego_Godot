extends Node

var current_checkpoint_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_checkpoint_position(new_position: Vector2) -> void:
	if new_position == Vector2.ZERO:
		push_error("Error de validación: Intento de guardar un checkpoint nulo.")
		return
		
	current_checkpoint_position = new_position

func get_respawn_position() -> Vector2:
	if current_checkpoint_position == Vector2.ZERO:
		push_warning("Advertencia: No hay checkpoint registrado. Retornando origen.")
		
	return current_checkpoint_position
