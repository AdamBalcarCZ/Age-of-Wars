extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var selection_ring = $SelectionRing

var speed = 5.0
var target_pos = Vector3.ZERO

func _ready():
	if GameData:
		speed = GameData.unit_stats["Peasant"]["speed"]

func move_to_position(pos):
	nav_agent.target_position = pos

func set_selected(is_selected):
	selection_ring.visible = is_selected

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return

	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed

	# Otočení
	if direction.length() > 0.1:
		look_at(global_position + direction)

	move_and_slide()
