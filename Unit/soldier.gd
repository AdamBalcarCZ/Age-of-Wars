class_name SoldierUnit
extends CharacterBody2D

@export var health: int = 150
@export var max_health: int = 150
@export var damage: int = 25
@export var attack_range: float = 70.0
@export var attack_rate: float = 1.0
@export var speed: float = 75.0 

@onready var box = get_node_or_null("Selected")
@onready var health_bar = get_node_or_null("HealthBar")

var waypoints: Array[Vector2] = []
var selected: bool = false
var can_attack: bool = true

func _ready(): 
	add_to_group("units") # Still in the 'units' group so enemies target them
	input_pickable = true
	
	selected = false
	if box: box.visible = false
	
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
		health_bar.visible = true # Soldiers always show their health

func take_damage(amount: int):
	health -= amount
	if health_bar:
		health_bar.value = health
		health_bar.visible = true 
	
	modulate = Color.RED
	create_tween().tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if health <= 0:
		queue_free()

func _physics_process(_delta):
	if waypoints.size() > 0:
		velocity = global_position.direction_to(waypoints[0]) * speed
		if global_position.distance_to(waypoints[0]) < 5: 
			waypoints.pop_front()
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		auto_attack_logic()

func auto_attack_logic():
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
				await get_tree().create_timer(attack_rate).timeout
				can_attack = true
				break

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
		waypoints = [get_global_mouse_position()]
