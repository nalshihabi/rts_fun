extends Area2D

signal new_click(item)

const SPEED = 50

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dir = 0
var selected = false
var current_location = Vector2(0, 0)
var dest = Vector2(0, 0)
var progress_visible = false

func toggle_progress_visible():
	if progress_visible:
		progress_visible = false
		$ProgressBar.visible = false
	else:
		progress_visible = true
		$ProgressBar.visible = true

func click():
	emit_signal("new_click", self)
	toggle_progress_visible()

func unclick():
	toggle_progress_visible()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input_event(_viewport, event, _shape_idx):
	# if event.type == InputEvent.MOUSE_BUTTON \
	# and event.button_index == BUTTON_LEFT \
	# and event.pressed:
	# 	print("Clicked")

	if event.get_button_mask() == 1:
		# toggle_progress_visible()
		click()
		print("Clicked")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
