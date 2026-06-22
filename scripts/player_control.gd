extends CharacterBody2D

const MAXSPEED = 300.0
const MAXFALLSPEED = 1000.0
const ACCEL = 100.0
const JUMP_VELOCITY = -400.0

const GROUNDFRICTION = 100.0
const AIRFRICTION = 10.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = clamp(velocity.y,-MAXFALLSPEED,MAXFALLSPEED)

	# Handle jump.
	if Input.is_action_just_pressed("up"):
		handle_jump()
	
	#DRAG
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, AIRFRICTION)
	
	
	var direction := Input.get_axis("left", "right")
	if direction and abs(velocity.x) < MAXSPEED:
		velocity.x += direction * ACCEL
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, GROUNDFRICTION)

	
	
	
	move_and_slide()
	
	if is_touching_death_plane():
		die()

func handle_jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		return
	
	if is_in_water():
		velocity.y = JUMP_VELOCITY/2

func is_touching_death_plane():
	var areas = $detect_area.get_overlapping_areas()
	
	for area: Area2D in areas:
		if area.is_in_group("death_plane"):
			return true
	
	return false

func die():
	global_position = Vector2.ZERO


func is_in_water() -> bool:
	var areas = $detect_area.get_overlapping_areas()
	
	for area: Area2D in areas:
		if area.is_in_group("water"):
			return true
	
	return false
