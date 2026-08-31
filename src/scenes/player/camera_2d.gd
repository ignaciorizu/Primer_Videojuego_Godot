extends Camera2D

const BOUNDARY_LEFT: int = 36
const BOUNDARY_RIGHT: int = 2085
const BOUNDARY_TOP: int = -1150
const BOUNDARY_BOTTOM: int = 650

func _ready() -> void:
	validate_boundaries()
	apply_camera_boundaries()

func validate_boundaries() -> void:
	if BOUNDARY_LEFT >= BOUNDARY_RIGHT or BOUNDARY_TOP >= BOUNDARY_BOTTOM:
		push_error("Error de validación: Límites de cámara inconsistentes detectados.")

func apply_camera_boundaries() -> void:
	limit_left = BOUNDARY_LEFT
	limit_right = BOUNDARY_RIGHT
	limit_top = BOUNDARY_TOP
	limit_bottom = BOUNDARY_BOTTOM
