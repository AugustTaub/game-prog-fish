extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var delta_timer: float = 0
@onready var goal_point: Vector2 = Vector2(0,global_position.y)

var curr_water_level: float = 500

func _ready() -> void:
	SignalBus.water_level_changed.connect(func(level): curr_water_level = level)


func _physics_process(delta: float) -> void:
	
	delta_timer += delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()/2 * delta
	
	
	if delta_timer > 3:
		delta_timer = 0
		goal_point.x = randf_range(global_position.x-500,global_position.x+500)
		goal_point.y = global_position.y
	
	
	var direction = global_position.direction_to(goal_point)
	velocity = direction * SPEED

	move_and_slide()
