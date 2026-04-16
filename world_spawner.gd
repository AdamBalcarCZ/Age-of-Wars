extends Node2D

@export var enemy_scene: PackedScene = preload("res://Unit/enemy.tscn")

@export var spawn_interval: float = 20.0
@export var main_base_pos: Vector2 = Vector2(1280, 1280)
@export var spawn_distance: float = 350.0 # How far from base they appear

@onready var timer = $Timer

func _ready():
	timer.wait_time = spawn_interval
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_zombie_swarm()

func spawn_zombie_swarm():
	var swarm_size = randi_range(3, 10)
	
	# Calculate a random point on the circle edge around (1280, 1280)
	var angle = randf() * TAU # Picks a random direction (0 to 360 degrees)
	var direction = Vector2(cos(angle), sin(angle))
	var spawn_center = main_base_pos + (direction * spawn_distance)
	
	print("Swarm spawning at: ", spawn_center)

	for i in range(swarm_size):
		var zombie = enemy_scene.instantiate()
		
		# Add to the scene tree
		get_tree().current_scene.add_child(zombie)
		
		# Give them a little personal space so they don't overlap
		var offset = Vector2(randf_range(-40, 40), randf_range(-40, 40))
		zombie.global_position = spawn_center + offset
