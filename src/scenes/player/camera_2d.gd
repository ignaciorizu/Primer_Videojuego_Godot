extends Camera2D

const BOUNDARY_LEFT: int = -1000
const BOUNDARY_RIGHT: int = 1920
const BOUNDARY_TOP: int = -1080
const BOUNDARY_BOTTOM: int = 1000

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
