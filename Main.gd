extends Node2D

const controller = preload("game_controller.gd")
const actions = preload("game_actions.gd")
const model = preload("game_model.gd")

var menu_controller = null
var main_model = null

func _ready():
	print("starting main")
	print("we got ", controller)
	remove_child($game_viewer)
	# main_model = model.instance()
