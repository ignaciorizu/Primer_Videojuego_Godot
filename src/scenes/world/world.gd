extends Node2D

@onready var _player_node: CharacterBody2D = $Personaje
@onready var _win_zone_node: Area2D = $WinZone

func _ready() -> void:
	_validate_nodes()
	_evaluate_initial_cutscene()

func _validate_nodes() -> void:
	if _player_node == null or _win_zone_node == null:
		push_error("Error critico: Fallo en la vinculacion de nodos locales.")

func _evaluate_initial_cutscene() -> void:
	var is_played: bool = GameState.is_intro_played()
	var action: Callable = { true: _skip_intro, false: _play_intro }[is_played]
	action.call()

func _play_intro() -> void:
	GameState.register_intro_played()
	_player_node.execute_intro_sequence(_win_zone_node.global_position)

func _skip_intro() -> void:
	pass
