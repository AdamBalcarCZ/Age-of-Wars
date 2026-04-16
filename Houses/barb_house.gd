extends StaticBody2D

@onready var select = $Selected 

func _ready() -> void:
	if select: select.visible = false

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("LeftClick"):
		get_tree().current_scene.deselect_all()
		set_selected(true)
		get_viewport().set_input_as_handled()

func set_selected(value: bool) -> void:
	if select: select.visible = value
	if value: 
		# --- FEATURE: OPEN SPAWN MENU ---
		Game.spawnUnit(global_position)
