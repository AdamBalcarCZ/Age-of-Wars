extends StaticBody2D

@export var total_time: float = 5.0 
@export var wood_reward: int = 5 # Set the wood amount here

var curr_time: float
var units: int = 0

@onready var bar: ProgressBar = $ProgressBar
@onready var timer: Timer = $Timer

func _ready() -> void:
	add_to_group("trees")
	curr_time = total_time
	if bar:
		bar.max_value = total_time
		bar.value = curr_time

func _process(_delta: float) -> void:
	if bar:
		bar.value = curr_time
	
	if curr_time <= 0:
		tree_chopped()

func _on_chop_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("units"):
		units += 1
		start_chopping()

func _on_chop_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("units"):
		units -= 1
		if units <= 0:
			units = 0
			timer.stop()

func _on_timer_timeout() -> void:
	# Subtract time based on how many units are working
	curr_time -= 1.0 * units

func start_chopping() -> void:
	if timer.is_stopped():
		timer.start()

func tree_chopped() -> void:
	# Add the wood to your global resources
	Game.Wood += wood_reward
	print("Tree chopped! +5 Wood. Total Wood: ", Game.Wood)
	
	# var p = pop_scene.instantiate()
	# get_tree().current_scene.add_child(p)
	# p.global_position = global_position
	# p.show_value(wood_reward)

	queue_free()
