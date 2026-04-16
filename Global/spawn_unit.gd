extends Node2D

var target_spawn_point: Vector2

func _on_yes_pressed():
	if Game.Wood >= Game.UNIT_COST_WOOD and Game.Gold >= Game.UNIT_COST_GOLD:
		Game.Wood -= Game.UNIT_COST_WOOD
		Game.Gold -= Game.UNIT_COST_GOLD
		var u = preload("res://Unit/unit.tscn").instantiate()
		get_tree().current_scene.get_node("Units").add_child(u)
		u.global_position = target_spawn_point + Vector2(randf_range(-50, 50), 80)
		queue_free()

func _on_no_pressed(): queue_free()
