extends Camera2D

# --- CAMERA SETTINGS ---
@export var SPEED: float = 450.0 
@export var ZOOM_SPEED: float = 15.0
@export var ZOOM_MARGIN: float = 0.1
@export var ZOOM_MIN: float = 0.5
@export var ZOOM_MAX: float = 3.0

var start: Vector2 = Vector2.ZERO
var end: Vector2 = Vector2.ZERO
var startV: Vector2 = Vector2.ZERO
var endV: Vector2 = Vector2.ZERO
var isDragging: bool = false
var drag_threshold: float = 12.0 

var target_zoom: float = 1.0 
var zoomPos: Vector2 = Vector2.ZERO
var zooming: bool = false

signal area_selected

func _ready() -> void:
	target_zoom = zoom.x

func _process(delta: float) -> void:
	# --- FEATURE: WASD MOVEMENT ---
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * SPEED * (1.0 / zoom.x) * delta
	
	# --- FEATURE: SMOOTH LERP ZOOM ---
	zoom.x = lerp(zoom.x, target_zoom, ZOOM_SPEED * delta)
	zoom.y = zoom.x
	if zooming:
		position = position.lerp(zoomPos, ZOOM_SPEED * delta * 0.1)
		if abs(zoom.x - target_zoom) < 0.01: zooming = false

	# --- FEATURE: SELECTION BOX DRAWING ---
	if Input.is_action_just_pressed("LeftClick"):
		start = get_global_mouse_position()
		startV = get_viewport().get_mouse_position()
		isDragging = true
		
	if isDragging:
		end = get_global_mouse_position()
		endV = get_viewport().get_mouse_position()
		if startV.distance_to(endV) > drag_threshold: draw_area(true)

	if Input.is_action_just_released("LeftClick"):
		if isDragging:
			isDragging = false
			if startV.distance_to(endV) > drag_threshold: area_selected.emit(self)
			draw_area(false)

# --- FEATURE: MOUSE WHEEL ZOOM ---
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom + ZOOM_MARGIN, ZOOM_MIN, ZOOM_MAX)
			zooming = true
			zoomPos = get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom - ZOOM_MARGIN, ZOOM_MIN, ZOOM_MAX)
			zooming = true
			zoomPos = get_global_mouse_position()

func draw_area(val: bool) -> void:
	var panel = get_node_or_null("../UI/Panel")
	if not panel: return
	if not val: panel.size = Vector2.ZERO; return
	panel.position = Vector2(min(startV.x, endV.x), min(startV.y, endV.y))
	panel.size = (startV - endV).abs()
