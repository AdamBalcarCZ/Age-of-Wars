extends Node2D

# 1. Preload the Soldier instead of the Worker
@onready var soldier_scene = preload("res://unit/Soldier.tscn")
@onready var main_panel = $Panel 

var target_spawn_point: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if main_panel and not main_panel.get_global_rect().has_point(get_global_mouse_position()):
			get_viewport().set_input_as_handled()
			queue_free()

# 2. Only the Soldier Button logic remains
func _on_soldier_pressed() -> void:
	if Game.Wood >= Game.SOLDIER_COST_WOOD and Game.Gold >= Game.SOLDIER_COST_GOLD:
		Game.Wood -= Game.SOLDIER_COST_WOOD
		Game.Gold -= Game.SOLDIER_COST_GOLD
		spawn_helper(soldier_scene.instantiate())
	else:
		print("Not enough Wood/Gold for a Soldier!")

func spawn_helper(u):
	var units_folder = get_tree().current_scene.get_node_or_null("Units")
	if units_folder:
		units_folder.add_child(u)
	else:
		get_tree().current_scene.add_child(u)
	
	u.global_position = target_spawn_point + Vector2(randf_range(-40, 40), 60)
	
	if u.has_method("set_selected"):
		u.set_selected(false)
		
	queue_free()
