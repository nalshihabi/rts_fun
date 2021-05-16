extends Node2D

signal new_click(item)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_mouse_pressed = false

var pressed = {}

func new_click_handler(inp):
	print("got a click")
	for i in pressed:
		if i != inp:
			i.unclick()

	pressed = {}
	pressed[inp] = inp

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect("new_click", self, "new_click_handler", [])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouse:
		if event.is_action_pressed('ui_click'):
			if event.get_button_mask() == 1:
				if is_mouse_pressed:
					print("mouse already clicked")
				else:
					is_mouse_pressed = true
					print("detected mouse left click")
			elif event.get_button_mask() == 2:
				print("detected mouse right click")
		elif event.is_action_released('ui_click'):
			is_mouse_pressed = false
			print("got here")


# func _process(delta):

# 	if is_action_just_pressed("ui_select"):
# 		print("just single clicked")
		## done once when the key is pressed


func _on_soldier_new_click(item):
	print("got ", item)
	self.new_click_handler(item)
	pass # Replace with function body.
