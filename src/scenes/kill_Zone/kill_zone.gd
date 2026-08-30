extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		call_deferred("_process_player_damage")

func _process_player_damage() -> void:
	world.subtract_life()
	get_tree().reload_current_scene()
