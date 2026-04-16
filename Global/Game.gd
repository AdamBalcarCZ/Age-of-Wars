extends Node

@onready var spawn_ui_scene = preload("res://Global/spawn_unit.tscn")

# --- RESOURCES ---
var Wood: int = 100
var Gold: int = 100

# --- COSTS ---
const UNIT_COST_WOOD = 25
const UNIT_COST_GOLD = 15

func spawnUnit(house_position: Vector2) -> void:
	var ui_layer = get_tree().get_root().get_node_or_null("World/UI")
	if not ui_layer: return
	
	if not ui_layer.has_node("SpawnMenu"):
		var menu = spawn_ui_scene.instantiate()
		menu.name = "SpawnMenu"
		menu.target_spawn_point = house_position 
		ui_layer.add_child(menu)
