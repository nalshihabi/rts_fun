extends GameObject

signal new_click(item)

var lazer := load("res://lazer.tscn")

# var a = resource

const SPEED = 50
const STOP_RADIUS = 10

const STATE_IDLE = 0
const STATE_MOVE = 1
const STATE_ATTACK = 2
const STATE_ATTACK_MOVE = 3

const ATTACK_WAIT = 60
const MAX_ATTACK_TIMER = 5000

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
var attack_timer = 0
var health = 0.0
var max_health = 100.0

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

func calc_speed(delta: float, other_position: Vector2) -> Vector2:
	var vec = other_position - self.position
	return vec.normalized() * delta * SPEED

func increment_attack_timer() -> void:
	if self.attack_timer > MAX_ATTACK_TIMER:
		self.attack_timer = ATTACK_WAIT

	self.attack_timer += 1

func fire_lazer(targ_loc: Vector2) -> void:
	print(lazer)
	var new_lazer = lazer.instance()
	$"..".add_child(new_lazer)
	new_lazer.init(self, targ_loc)
	pass

func attack(targ_loc: Vector2) -> void:
	if self.attack_timer >= ATTACK_WAIT:
		fire_lazer(targ_loc)
		self.attack_timer = 0

func reset_state():
	self.state = STATE_IDLE

func draw_path(path: PoolVector2Array):
	var dpath = []
	for i in path:
		dpath.append(i - self.position)
	
	$Line2D.points = dpath
	# draw_polyline(path, Color.green)

func move_attack(delta: float, cur_target: Object) -> void:
	if self.position.distance_to(cur_target.position) < attack_range:
		self.state = STATE_ATTACK
		attack(cur_target.position)
	else:
		self.state = STATE_ATTACK_MOVE
		var path = self.nav.get_simple_path(self.position, cur_target.position)
		self.draw_path(path)
		var _collision := self.move_and_collide(calc_speed(delta, path[1]))

func set_attack(new_target: Object, new_target_location: Vector2, new_nav: Object) -> void:
	self.target_location = new_target_location
	self.target = new_target
	self.nav = new_nav
	self.state = STATE_ATTACK_MOVE

func receive_attack(damage: float) -> void:
	self.lower_health(damage)

func increase_health(amount: float) -> void:
	set_health(self.health + amount)

func lower_health(amount: float) -> void:
	set_health(self.health - amount)

func set_health(new_health: float) -> void:
	self.health = new_health
	if self.health != self.max_health:
		$ProgressBar.visible = true
	$ProgressBar.value = self.health
	if self.health < 0.0:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.object_type = "ORANGE_SOLDIER"
	target_location = self.position
	self.set_health(self.max_health)

func _physics_process(delta: float) -> void:
	increment_attack_timer()
	
	if self.position.distance_to(target_location) > STOP_RADIUS and (state == STATE_IDLE or state == STATE_MOVE):
		state = STATE_MOVE
		var path: PoolVector2Array = self.nav.get_simple_path(self.position, target_location)
		self.draw_path(path)
		var _collision := self.move_and_collide(calc_speed(delta, target_location))
	elif self.state == STATE_ATTACK or self.state == STATE_ATTACK_MOVE:
		if target:
			move_attack(delta, target)
		else:
			state = STATE_IDLE
	elif self.state != STATE_ATTACK and self.state != STATE_ATTACK_MOVE:
		state = STATE_IDLE
