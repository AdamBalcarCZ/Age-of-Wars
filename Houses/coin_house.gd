extends StaticBody2D

@onready var bar = $ProgressBar
@onready var timer = $Timer
@onready var select = get_node_or_null("Selected")
@onready var pop_scene = preload("res://Houses/Pop.tscn") # Check capitalization here too just in case!

var max_time: float = 4.0
var current_time: float = 4.0
var units_working: int = 0

func _ready():
	# CRITICAL FIX: The house must formally join the group itself!
	add_to_group("houses")
	
	bar.max_value = max_time
	bar.value = max_time

func _on_labor_area_body_entered(body):
	if body.is_in_group("units"): 
		units_working += 1
		if timer.is_stopped(): 
			timer.start()

func _on_labor_area_body_exited(body):
	if body.is_in_group("units"):
		units_working = max(0, units_working - 1)
		if units_working == 0: 
			timer.stop()

func _on_timer_timeout():
	# Progress the countdown
	current_time -= (1.0 * units_working)
	
	# Smoothly update the bar
	var tw = create_tween()
	tw.tween_property(bar, "value", current_time, 0.1)
	
	if current_time <= 0:
		# Reward
		Game.Gold += 15
		
		# Popup Text
		var p = pop_scene.instantiate()
		get_tree().current_scene.add_child(p)
		p.global_position = global_position + Vector2(-20, -50)
		if p.has_method("show_value"):
			p.show_value(15)
			
		# RESET LOGIC
		current_time = max_time
		bar.value = max_time
