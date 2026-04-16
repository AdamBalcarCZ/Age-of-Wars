extends Node2D

@onready var tree_scene = preload("res://World Objects/tree.tscn")
@onready var barracks_scene = preload("res://Houses/BarbHouse.tscn")
@onready var coin_house_scene = preload("res://Houses/coin_house.tscn")
@onready var enemy_scene = preload("res://Unit/enemy.tscn")

# --- GRID SETTINGS ---
var tile_size: int = 16 
var grid_size: Vector2 = Vector2(160, 160)
var grid: Array = []

func _ready() -> void:
	# 1. Initialize Grid
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y): grid[x].append(null)
			
	# 2. Register Editor Buildings
	var pre_placed_mines = 0
	for folder in ["Houses", "Resources"]:
		if has_node(folder):
			for node in get_node(folder).get_children():
				var tx = int(round(node.position.x / tile_size))
				var ty = int(round(node.position.y / tile_size))
				if tx >= 0 and tx < grid_size.x and ty >= 0 and ty < grid_size.y:
					grid[tx][ty] = "Building"
					# Count how many mines you placed manually in the editor
					if folder == "Resources": pre_placed_mines += 1
			
	var center_tile = Vector2(80, 80) 
	var center_px = center_tile * tile_size
	var safe_radius = 250.0 / tile_size 
	
	# 3. Generation
	spawn_scattered_trees(center_tile, 6.0, safe_radius, 35) 
	spawn_forest_clusters(center_tile, safe_radius)         
	
	# FIXED: Only spawn enough to reach a total of 4 mines
	var mines_to_spawn = max(0, 4 - pre_placed_mines)
	spawn_random_coin_houses(mines_to_spawn)           
	
	spawn_enemy_ring(center_px, 8)                         
	generate_random_trees(40)                              

# --- GENERATION LOGIC ---
func spawn_forest_clusters(center: Vector2, safe_r: float):
	for i in range(randi_range(12, 22)):
		var angle = randf_range(0, TAU)
		var dist = randf_range(safe_r + 5.0, 75.0) 
		var cluster_center = center + Vector2(cos(angle), sin(angle)) * dist
		spawn_scattered_trees(cluster_center, 0.0, randf_range(4.0, 15.0), randi_range(20, 130))

func spawn_enemy_ring(center: Vector2, amount: int):
	for i in range(amount):
		var spawn_pos = center + Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(450, 550)
		var e = enemy_scene.instantiate()
		if has_node("Units"): $Units.add_child(e)
		else: add_child(e)
		e.global_position = spawn_pos

func spawn_random_coin_houses(amount: int):
	var spawned = 0
	# Safety exit if map is too crowded
	var attempts = 0 
	while spawned < amount and attempts < 100:
		attempts += 1
		var tx = randi() % int(grid_size.x); var ty = randi() % int(grid_size.y)
		if grid[tx][ty] == null:
			grid[tx][ty] = "Resource"
			var ch = coin_house_scene.instantiate()
			if has_node("Resources"): $Resources.add_child(ch)
			else: add_child(ch)
			ch.position = Vector2(tx, ty) * tile_size
			spawned += 1

func spawn_scattered_trees(center: Vector2, min_r: float, max_r: float, amt: int):
	var spawned = 0
	for i in range(amt * 10):
		if spawned >= amt: break
		var offset = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(min_r, max_r)
		var tx = int(round(center.x + offset.x)); var ty = int(round(center.y + offset.y))
		if tx >= 0 and tx < grid_size.x and ty >= 0 and ty < grid_size.y:
			if grid[tx][ty] == null:
				grid[tx][ty] = "Tree"; var t = tree_scene.instantiate()
				if has_node("Resources"): $Resources.add_child(t)
				else: add_child(t); t.position = Vector2(tx, ty) * tile_size
				spawned += 1

func generate_random_trees(amt: int):
	var spawned = 0
	for i in range(amt * 5):
		if spawned >= amt: break
		var tx = randi() % int(grid_size.x); var ty = randi() % int(grid_size.y)
		if grid[tx][ty] == null:
			grid[tx][ty] = "Tree"; var t = tree_scene.instantiate()
			if has_node("Resources"): $Resources.add_child(t)
			else: add_child(t); t.position = Vector2(tx, ty) * tile_size
			spawned += 1

# --- SELECTION & INPUT ---
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"): deselect_all()

func deselect_all():
	for group in ["Units", "Houses", "Resources"]:
		if has_node(group):
			for s in get_node(group).get_children():
				if s.has_method("set_selected"): s.set_selected(false)

func _on_camera_area_selected(object):
	var box = Rect2(object.start, object.end - object.start).abs()
	deselect_all()
	for group in ["Units", "Houses", "Resources"]:
		if has_node(group):
			for n in get_node(group).get_children():
				if box.has_point(n.global_position) and n.has_method("set_selected"):
					n.set_selected(true)
