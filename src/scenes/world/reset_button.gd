extends Control

const INITIAL_LEVEL_PATH: String = "res://src/scenes/world/world.tscn"
const INPUT_ACTION_ACCEPT: String = "ui_accept"

@onready var _button_reference: Button = $BaseButton

func _ready() -> void:
	_button_reference.pressed.connect(_execute_game_restart)
	_validate_setup()

func _input(event: InputEvent) -> void:
	_evaluate_keyboard_input(event)

func _evaluate_keyboard_input(event: InputEvent) -> void:
	if event.is_action_pressed(INPUT_ACTION_ACCEPT):
		get_viewport().set_input_as_handled()
		_execute_game_restart()

func _validate_setup() -> void:
	if _button_reference == null:
		push_error("Error critico: Referencia nula para BaseButton.")
		return
	if INITIAL_LEVEL_PATH == "":
		push_error("Error critico: Ruta de nivel inicial vacia.")
		return

func _execute_game_restart() -> void:
	get_tree().change_scene_to_file.call_deferred(INITIAL_LEVEL_PATH)
