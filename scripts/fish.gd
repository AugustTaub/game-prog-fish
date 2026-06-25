extends CharacterBody2D

class_name FishEnemy

const SPEED = 150.0

@export var max_health: float = 100.0
@onready var curr_health: float = max_health

var delta_timer: float = 0
@onready var goal_point: Vector2 = Vector2(0,global_position.y)

var curr_water_level: float = 500

func _ready() -> void:
	SignalBus.water_level_changed.connect(func(level): curr_water_level = level)
	set_health(curr_health)

func set_health(new_health: float):
	curr_health = clamp(new_health,0,max_health)
	$health_bar.value = curr_health/max_health

func take_damage(damage: float):
	set_health(curr_health-damage)

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
