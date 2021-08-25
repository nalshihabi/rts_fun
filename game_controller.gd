extends Node2D

# const Item = preload("item.gd")

const ACTIONS = preload("game_actions.gd")

var vis: bool = true
var items: Dictionary = {}

class Item:
	var id: int
	var position: Vector2
	var orientation: float
	var resource_type: String

	func _init(object: GameObject):
		# self.type = null
		# print(object.get_class(), " ", object.get_script().get_tree().get_current_scene_name())
		print(object.get_class(), " ", object.get_object_type())
		self.id = object.get_instance_id()
		self.position = object.position
		self.orientation = object.orientation
		# self.resource_type = object.get_script().get_path()
		self.resource_type = object.get_object_type()


func parse_item(item: Object) -> Item:
	if !item.is_class("GameObject"):
	# if !item.is_class(GameObject.object_type):
		return null

	return Item.new(item)

func get_items_local():
	pass

func _ready():
	print("here")
	print("got action ", ACTIONS.ACTIONS.REFRESH_SELECTED)

func _process(delta):
	# Actually game_viewer currently but refactor will happen later
	var game_model: Node2D = $game_model
	items = {}
	for child in game_model.get_children():
		var item: Item = parse_item(child)
		if item:
			items[item.id] = item
