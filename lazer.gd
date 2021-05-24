extends KinematicBody2D

const SPEED = 100
const RANGE = 500

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var target_location = Vector2(0, 0)
var starting_position = Vector2(0, 0)
var dir = 0


func _init(target:Vector2 = Vector2(0, 0), dir: Vector2 = Vector2(0, 0)):
	self.target_location = target
	self.dir = dir.normalized()

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = self.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	self.move_and_collide(dir * delta * SPEED)
	if starting_position.distance_to(self.position) > RANGE:
		self.queue_free()
