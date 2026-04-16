extends StaticBody2D

@onready var select = $Selected
@onready var unit_scene = preload("res://unit/Unit.tscn")

func _ready() -> void:
	add_to_group("player_buildings")
	add_to_group("selectables")
	add_to_group("player_owned")
	if select: select.visible = false

func _input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("LeftClick"):
		get_tree().current_scene.deselect_all()
		set_selected(true)
		get_viewport().set_input_as_handled()
		
		# Instantly train the unit
		train_soldier()

func set_selected(val):
	if select: select.visible = val
	
	# Open the menu when selected!
	if val: 
		Game.spawnUnit(global_position)

func train_soldier():
	if Game.Wood >= Game.SOLDIER_COST_WOOD and Game.Gold >= Game.SOLDIER_COST_GOLD:
		Game.Wood -= Game.SOLDIER_COST_WOOD
		Game.Gold -= Game.SOLDIER_COST_GOLD
		
		var s = unit_scene.instantiate()
		var unit_folder = get_tree().current_scene.get_node_or_null("Units")
		if unit_folder: 
			unit_folder.add_child(s)
		else: 
			get_tree().current_scene.add_child(s)
		
		var offset = Vector2(randf_range(-80, 80), 100)
		s.global_position = global_position + offset
		print("Soldier trained!")
	else:
		print("Not enough resources!")
		
		
