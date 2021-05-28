extends KinematicBody2D

const SPEED = 100
const RANGE = 500
const ATTACK_DAMAGE = 10

var target_location = Vector2(0, 0)
var starting_position = Vector2(0, 0)
var dir = Vector2.ZERO
var par: KinematicBody2D = null

# func _init(pos: Vector2 = Vector2.ZERO, target: Vector2 = Vector2(0, 0)) -> void:
func init(new_par: KinematicBody2D, target: Vector2 = Vector2(0, 0)) -> void:
	self.par = new_par
	self.position = par.position
	self.starting_position = self.position
	self.target_location = target
	self.dir = (target - self.position).normalized()
	self.rotate(atan2(self.dir.y, self.dir.x))

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = self.position

func _on_body_entered(body):
	if body != self.par:
		if funcref(body, "receive_attack").is_valid():
			body.receive_attack(ATTACK_DAMAGE)
		else:
			# TODO: Figure out what I want to do here
			pass

		queue_free()

func _physics_process(delta):
	var _collision := self.move_and_collide(dir * delta * SPEED)

	if starting_position.distance_to(self.position) > RANGE:
		self.queue_free()
