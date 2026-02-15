extends Camera3D

var move_speed = 20.0
var selected_units = []

func _process(delta):
	# Pohyb kamery
	var dir = Input.get_vector("camera_left", "camera_right", "camera_forward", "camera_back")
	global_position += Vector3(dir.x, 0, dir.y) * move_speed * delta

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		# VÝBĚR
		var result = raycast(event.position, 2)
		if result and result.collider.has_method("set_selected"):
			for u in selected_units: u.set_selected(false)
			selected_units.clear()

			var unit = result.collider
			unit.set_selected(true)
			selected_units.append(unit)
			print("Vybráno: ", unit.name)

	elif event.is_action_pressed("right_click"):
		# POHYB
		var result = raycast(event.position, 1)
		if result:
			print("Pohyb na: ", result.position)
			for unit in selected_units:
				unit.move_to_position(result.position)

func raycast(screen_pos, mask):
	var from = project_ray_origin(screen_pos)
	var to = from + project_ray_normal(screen_pos) * 1000
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = mask
	return space.intersect_ray(query)
