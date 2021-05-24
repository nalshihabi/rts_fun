extends KinematicBody2D

signal new_click(item)

const SPEED = 50
const STOP_RADIUS = 10

const STATE_IDLE = 0
const STATE_MOVE = 1
const STATE_ATTACK = 2
const STATE_ATTACK_MOVE = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dir = 0
var selected = false
var current_location = Vector2(0, 0)
var target = null
var target_location = Vector2(0, 0)
var dest = Vector2(0, 0)
var progress_visible = false
var attack_range = 100
var state = STATE_IDLE
var nav = null

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

func calc_speed(delta, other_position):
	var vec = other_position - self.position
	return vec.normalized() * delta * SPEED

func attack(target):
	print("I am attacking!")
	pass

func reset_state():
	self.state = STATE_IDLE

func draw_path(path: PoolVector2Array):
	# path = [i - self.global_position for i in path]
	var dpath = []
	for i in path:
		dpath.append(i - self.position)
	
	$Line2D.points = dpath

func move_attack(delta, target):
	if self.position.distance_to(target.position) < attack_range:
		state = STATE_ATTACK
		attack(target)
	else:
		# print("hello?????")
		state = STATE_ATTACK_MOVE
		var path = self.nav.get_simple_path(self.position, target.position)
		# $Line2D.points = path
		self.draw_path(path)
		# self.move_and_collide(calc_speed(delta, target.position))
		self.move_and_collide(calc_speed(delta, path[0]))

func set_attack(target, target_location, nav):
	print("in set attack")
	self.target_location = target_location
	self.target = target
	self.nav = nav
	self.state = STATE_ATTACK_MOVE

# Called when the node enters the scene tree for the first time.
func _ready():
	target_location = self.position
	pass # Replace with function body.

func _physics_process(delta):
	if self.position.distance_to(target_location) > STOP_RADIUS and (state == STATE_IDLE or state == STATE_MOVE):
		state = STATE_MOVE
	# if self.position != target_location:
		# var vec = target_location - self.position
		var path = self.nav.get_simple_path(self.position, target_location)
		# $Line2D.points = path
		self.draw_path(path)
		self.move_and_collide(calc_speed(delta, target_location))
	elif self.state == STATE_ATTACK or self.state == STATE_ATTACK_MOVE:
		# print("in physics process")
		move_attack(delta, target)
	elif self.state != STATE_ATTACK and self.state != STATE_ATTACK_MOVE:
		state = STATE_IDLE
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
