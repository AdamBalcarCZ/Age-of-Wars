extends StaticBody2D

# Load the NEW Soldier menu instead of the Worker menu
@onready var spawn_menu = preload("res://Houses/pop.tscn")

func _input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("LeftClick"):
		var menu = spawn_menu.instantiate()
		menu.target_spawn_point = global_position 
		get_tree().current_scene.add_child(menu)
		
		# Put the menu on the screen where you clicked
		menu.global_position = get_global_mouse_position()
