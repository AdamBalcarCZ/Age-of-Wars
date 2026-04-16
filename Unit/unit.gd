extends CharacterBody2D

@export var health: int = 100
@export var damage: int = 20
@export var attack_range: float = 110.0 # High enough to reach past collision
@export var attack_rate: float = 0.5
@export var speed: float = 75.0 # Boosted speed slightly to feel better

@onready var box = get_node_or_null("Selected")
@onready var health_bar = get_node_or_null("HealthBar")

var waypoints: Array[Vector2] = []
var selected: bool = false
var can_attack: bool = true

func _ready(): 
	add_to_group("units")
	input_pickable = true
	if box: box.visible = false
	if health_bar:
		health_bar.max_value = health
		health_bar.value = health

func _physics_process(_delta):
	# 1. MOVEMENT LOGIC
	if waypoints.size() > 0:
		var target_pos = waypoints[0]
		# Move toward the waypoint
		velocity = global_position.direction_to(target_pos) * speed
		
		# Check if we arrived (Distance of 10 is the sweet spot)
		if global_position.distance_to(target_pos) < 10:
			waypoints.pop_front()
	else:
		# Stop moving if no waypoints left
		velocity = Vector2.ZERO
		
		# 2. ATTACK LOGIC (Only attacks when standing still)
		auto_attack_logic()

	# 3. APPLY MOVEMENT
	move_and_slide()

func auto_attack_logic():
	# If we just attacked, wait for the cooldown
	if not can_attack: return
	
	var targets = get_tree().get_nodes_in_group("enemies")
	targets.append_array(get_tree().get_nodes_in_group("boss_building")) 
	
	for t in targets:
		if is_instance_valid(t):
			var dist = global_position.distance_to(t.global_position)
			if dist <= attack_range:
				can_attack = false
				
				if t.has_method("take_damage"):
					t.take_damage(damage)
				
				# Wait for the rate of fire
				await get_tree().create_timer(attack_rate).timeout
				can_attack = true
				break # Only hit one target at a time

func take_damage(amount: int):
	health -= amount
	if health_bar:
		health_bar.value = health
	
	modulate = Color.RED
	create_tween().tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if health <= 0:
		queue_free()

# --- SELECTION & INPUT ---

func set_selected(val):
	selected = val
	if box: box.visible = val

func _input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("LeftClick"):
		if get_tree().current_scene.has_method("deselect_all"):
			get_tree().current_scene.deselect_all()
		set_selected(true)
		get_viewport().set_input_as_handled()

func _input(event):
	if selected and event.is_action_pressed("RightClick"):
		# Set a new destination
		waypoints = [get_global_mouse_position()]
