extends CharacterBody2D

const MAXSPEED = 300.0
const MAXFALLSPEED = 1000.0
const ACCEL = 100.0
const JUMP_VELOCITY = -400.0
const POGO_VELOCITY = -450.0

const GROUNDFRICTION = 100.0
const AIRFRICTION = 10.0

var is_doing_flip: bool = false

@onready var start_pos: Vector2 = global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if is_doing_flip:
			velocity += get_gravity()/5 * delta
			velocity.y = clamp(velocity.y,-MAXFALLSPEED,MAXFALLSPEED)
		else:
			velocity += get_gravity() * delta
			velocity.y = clamp(velocity.y,-MAXFALLSPEED,MAXFALLSPEED)

	# Handle jump.
	if Input.is_action_just_pressed("up"):
		handle_jump()
	
	# flip
	if Input.is_action_just_pressed("down") and not is_doing_flip:
		var tween = create_tween()
		is_doing_flip = true
		tween.tween_property($vis_body,"rotation",$vis_body.rotation + 2*PI,0.5)
		
		await tween.finished
		is_doing_flip = false
	
	#DRAG
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, AIRFRICTION)
	
	#attack
	if Input.is_action_just_pressed("ui_accept"):
		
		var bodies = $attack_area.get_overlapping_bodies()
		for body: PhysicsBody2D in bodies:
			print(body)
			if body.is_in_group("can_be_pogod"):
				velocity.y = POGO_VELOCITY
			
		
		$attack_sprite.show()
		get_tree().create_timer(delta*4).timeout.connect(func(): $attack_sprite.hide())
	
	
	var direction := Input.get_axis("left", "right")
	if direction and abs(velocity.x) < MAXSPEED:
		velocity.x += direction * ACCEL
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, GROUNDFRICTION)
	
	
	$vis_body/sprite.flip_h = velocity.x < 0
	
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
	global_position = start_pos


func is_in_water() -> bool:
	var areas = $detect_area.get_overlapping_areas()
	
	for area: Area2D in areas:
		if area.is_in_group("water"):
			return true
	
	return false
