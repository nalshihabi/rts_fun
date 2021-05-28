extends Node2D

signal new_click(item)

# TODO: Probably want to eventually change to a ratio.
const EDGE_RANGE = 50

const CAMERA_MOVE_SPEED = 40

var is_mouse_pressed = false
var pressed = {}
var dragging = false  # Are we currently dragging?
var selected = []  # Array of selected units.
var previous = []  # Array of previously selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
var wh: Vector2 = Vector2.ZERO
var cam_vec: Vector2 = Vector2.ZERO

func refresh_selected():
	for item in previous:
		if item:
			item.collider.unclick()

	previous = selected
	for item in previous:
		if item:
			item.collider.click()

func within_edge_border_horizontal(position: Vector2) -> bool:
	return position.x < EDGE_RANGE or position.x > wh.x - EDGE_RANGE

func within_edge_border_vertical(position: Vector2) -> bool:
	return position.y < EDGE_RANGE or position.y > wh.y - EDGE_RANGE

func move_camera(pos: Vector2) -> void:
	# var dd := Vector2(1 if horizontal else 0, 1 if vertical else 0)
	# $Camera2D.position += dd * 
	var dx = 0
	var dy = 0

	if pos.x < EDGE_RANGE:
		dx = -1
	elif pos.x > wh.x - EDGE_RANGE:
		dx = 1

	if pos.y < EDGE_RANGE:
		dy = -1
	elif pos.y > wh.y - EDGE_RANGE:
		dy = 1

	cam_vec.x = dx
	cam_vec.y = dy

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# We only want to start a drag if there's no selection.

			if selected.size() == 0:
				dragging = true
				print("setting drag start ", event.position, " ", $Camera2D.position)
				drag_start = event.position + $Camera2D.position
			else:
				selected = []
				refresh_selected()
		elif dragging:
			# Button released while dragging.
			dragging = false
			update()
			var drag_end = event.position + $Camera2D.position
			select_rect.extents = (drag_end - drag_start) / 2

			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			selected = space.intersect_shape(query)
			
			refresh_selected()

	elif event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.pressed:
			var click_location = event.position + $Camera2D.position

			var space = get_world_2d().direct_space_state
			var target_selected = space.intersect_point(click_location)

			if len(target_selected) > 0:
				var target = target_selected[0]
				for item in selected:
					item.collider.set_attack(target.collider, target.collider.position, $Navigation2D)
			else:
				for item in selected:
					item.collider.nav = $Navigation2D
					item.collider.reset_state()
					item.collider.target_location = event.position + $Camera2D.position

	if event is InputEventMouseMotion:
		var loc = $Camera2D.position
		$Label.text = "(" + str(loc.x) + ", " + str(loc.y) + ")"
		move_camera(event.position)

	if event is InputEventMouseMotion and dragging:
		update()

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color(.5, .5, .5), false)


func new_click_handler(inp):
	print("got a click")
	for i in pressed:
		if i != inp:
			i.unclick()

	pressed = {}
	pressed[inp] = inp

# Called when the node enters the scene tree for the first time.
func _ready():
	wh = get_viewport().get_visible_rect().size
	$Camera2D.set_h_drag_enabled(true)
	$Camera2D.set_v_drag_enabled(true)

func _process(delta):
	$Camera2D.position += self.cam_vec * delta * CAMERA_MOVE_SPEED

func _on_soldier_new_click(item):
	print("got ", item)
	# self.new_click_handler(item)
	pass # Replace with function body.
