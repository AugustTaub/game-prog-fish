extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_in_water():
		apply_central_force((Vector2.UP)*200)
		rotation = move_toward(rotation,0,delta/2)

func is_in_water() -> bool:
	var areas = $detect_area.get_overlapping_areas()
	
	for area: Area2D in areas:
		if area.is_in_group("water"):
			return true
	
	return false
