extends StaticBody2D

@export var health: float = 300.0
@onready var enemy_scene = preload("res://Unit/enemy.tscn")

func _ready() -> void:
	add_to_group("enemies")
	add_to_group("selectables")

func _on_spawn_timer_timeout() -> void:
	if Game.grace_period_over:
		var e = enemy_scene.instantiate()
		var enemy_folder = get_tree().current_scene.get_node_or_null("Enemies")
		if enemy_folder: enemy_folder.add_child(e)
		else: get_parent().add_child(e)
		
		# Spawns closer to the building (Y offset 40)
		e.global_position = global_position + Vector2(randf_range(-30, 30), 40)

func take_damage(amount):
	health -= amount
	if health <= 0: queue_free()

func set_selected(val):
	if has_node("Selected"): $Selected.visible = val
