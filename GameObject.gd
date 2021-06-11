extends KinematicBody2D

class_name GameObject

var id: int = -1
var orientation: float = 0.0
var object_type: String = "GameObject"

func get_object_type() -> String:
	return self.object_type

func get_class() -> String:
	return "GameObject"

func is_class(className: String) -> bool:
	return className == "GameObject"