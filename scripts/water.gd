extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.water_level_changed.emit(global_position.y)
