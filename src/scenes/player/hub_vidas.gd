extends CanvasLayer

const OPACITY_MAP: Dictionary = {
	true: 1.0,
	false: 0.3
}

@onready var _life_icons: Array = [
	$HBoxContainer/TextureRect,
	$HBoxContainer/TextureRect2,
	$HBoxContainer/TextureRect3
]

func _ready() -> void:
	GameState.lives_changed.connect(update_lives_display)
	update_lives_display(GameState.get_current_lives())

func update_lives_display(current_lives: int) -> void:
	if current_lives < 0 or current_lives > _life_icons.size():
		push_error("Error de validacion: Rango de vidas invalido")
		return

	for index in range(_life_icons.size()):
		_life_icons[index].modulate.a = OPACITY_MAP[index < current_lives]
