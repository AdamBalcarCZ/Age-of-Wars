extends Node2D

@onready var tree = preload("res://World Objects/tree.tscn")
@onready var house = preload("res://Houses/coin_house.tscn")

var tile_size = 16

var grid_size = Vector2(160, 160)
var grid = []

func _ready() -> void:
	# 1. Build the 2D array correctly
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null) # <--- FIXED: Appends to the inner array
			
	var positions = []
	for i in range(50):
		# Used grid_size instead of grid.size
		var xcoor = (randi() % int(grid_size.x))
		var ycoor = (randi() % int(grid_size.y))
		
		var grid_pos = Vector2(xcoor, ycoor)
		
		if not grid_pos in positions:
			positions.append(grid_pos)
			
	print(positions)
	
	# Loop through the chosen positions to spawn all 50 trees
	for pos in positions:
		var new_tree = tree.instantiate()
		add_child(new_tree)
		
		# Multiply by tile_size so they sit perfectly on the grid!
		new_tree.position = pos * tile_size
