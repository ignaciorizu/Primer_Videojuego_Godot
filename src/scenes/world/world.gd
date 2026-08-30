extends Node

var current_checkpoint_position: Vector2 = Vector2.ZERO
const MAX_LIVES: int = 3
var current_lives: int = MAX_LIVES

signal lives_changed(new_lives_count: int)

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

func restore_life() -> void:
	if current_lives < MAX_LIVES:
		current_lives += 1
		lives_changed.emit(current_lives)
	
func subtract_life() -> void:
	current_lives -= 1
	lives_changed.emit(current_lives)
	
	if current_lives <= 0:
		_reset_game_state()

func _reset_game_state() -> void:
	current_lives = MAX_LIVES
	current_checkpoint_position = Vector2.ZERO
