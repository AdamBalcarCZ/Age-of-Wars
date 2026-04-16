extends Node2D

@export var house_scene: PackedScene = preload("res://Houses/coin_house.tscn")
@export var tree_scene: PackedScene = preload("res://World Objects/tree.tscn")

@export var main_pos: Vector2 = Vector2(1280, 1280)

# --- HOUSE SETTINGS ---
@export var max_houses: int = 4
@export var house_radius: float = 400.0
@export var house_spacing: float = 200.0

# --- TREE SETTINGS ---
@export var max_trees: int = 15
@export var tree_radius: float = 500.0
@onready var timer = $Timer

# Memory bank for houses we just spawned
var pending_house_positions: Array[Vector2] = []

func _ready():
	# Wait one frame for the world to be ready
	await get_tree().process_frame
	manage_resources()
	
	if timer:
		timer.wait_time = 5.0
		timer.start()
		timer.timeout.connect(manage_resources)

func manage_resources():
	pending_house_positions.clear() 

	# 1. Handle Houses
	var current_houses = get_tree().get_nodes_in_group("houses").size()
	var houses_to_spawn = max_houses - current_houses
	
	for i in range(houses_to_spawn):
		spawn_safe_house()
		
	# 2. Handle Trees
	var current_trees = get_tree().get_nodes_in_group("trees").size()
	var trees_to_spawn = max_trees - current_trees
	
	for i in range(trees_to_spawn):
		spawn_random_tree()

func spawn_safe_house() -> bool:
	for attempt in range(50):
		var angle = randf() * TAU
		var dist = randf() * house_radius
		var pos = main_pos + Vector2(cos(angle), sin(angle)) * dist
		
		if is_house_spot_safe(pos):
			pending_house_positions.append(pos)
			
			var h = house_scene.instantiate()
			h.add_to_group("houses") 
			h.position = pos # Set immediately
			get_tree().current_scene.add_child.call_deferred(h)
			
			return true
	return false

func is_house_spot_safe(pos: Vector2) -> bool:
	for house in get_tree().get_nodes_in_group("houses"):
		if is_instance_valid(house) and pos.distance_to(house.global_position) < house_spacing:
			return false
			
	for pending_pos in pending_house_positions:
		if pos.distance_to(pending_pos) < house_spacing:
			return false
			
	return true

func spawn_random_tree():
	var t = tree_scene.instantiate()
	var angle = randf() * TAU
	var dist = randf() * tree_radius
	var pos = main_pos + Vector2(cos(angle), sin(angle)) * dist
	
	t.add_to_group("trees")
	t.position = pos # Set immediately
	get_tree().current_scene.add_child.call_deferred(t)
