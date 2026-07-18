extends Node2D

## Manages the ragdoll's health, active balance, hit reaction, and death.
## Active balance keeps the ragdoll standing by applying corrective forces
## to the torso and legs until it dies — then it goes fully ragdoll.

signal health_changed(current_health: float, max_health: float)
signal died()

## ── Health ────────────────────────────────────────────────────────────
@export var max_health: float = 100.0

## ── Active balance ────────────────────────────────────────────────────
## When true, the torso is nudged upright each frame so the ragdoll stands.
@export var active_balance: bool = true
## How strongly the torso is pushed toward upright (higher = stiffer stance).
@export var balance_torque: float = 2500.0
## How strongly angular velocity is damped toward zero.
@export var angular_damping_force: float = 15.0
## Target upright angle (radians). 0 = straight up.
@export var target_angle: float = 0.0
## Upward force applied to the torso to keep it at spawn height.
@export var height_hold_force: float = 600.0
## Upward force applied to each lower leg to keep feet planted.
@export var leg_support_force: float = 300.0

## ── Death ──────────────────────────────────────────────────────────────
@export var death_impulse: float = 400.0

## ── Breakable limbs ───────────────────────────────────────────────────
@export var break_threshold: float = 0.0

## ── Internal state ────────────────────────────────────────────────────
var current_health: float
var is_dead: bool = false

var _body_parts: Array[RigidBody2D] = []
var _joints: Array[PinJoint2D] = []
var _limb_map: Dictionary = {}
var _joint_map: Dictionary = {}

var _torso: RigidBody2D = null
var _spawn_position: Vector2 = Vector2.ZERO

## Leg limb IDs (6=UpperLegL, 7=LowerLegL, 8=UpperLegR, 9=LowerLegR).
const LEG_IDS: Array[int] = [7, 9]


func _ready() -> void:
	current_health = max_health
	_spawn_position = global_position
	_collect_parts()
	_register_parts()


func _physics_process(delta: float) -> void:
	if is_dead or not active_balance or _torso == null:
		return
	_apply_balance(delta)


## ── Setup ──────────────────────────────────────────────────────────────

func _collect_parts() -> void:
	for child in get_children():
		if child is RigidBody2D:
			_body_parts.append(child)
			if "limb_id" in child:
				_limb_map[child.limb_id] = child
		elif child is PinJoint2D:
			_joints.append(child)


func _register_parts() -> void:
	for part in _body_parts:
		if part.has_method("setup"):
			part.setup(self)
		if "limb_id" in part and part.limb_id == 1:
			_torso = part

	for joint in _joints:
		if joint.node_a and joint.node_b:
			var body_a: Node = joint.get_node(joint.node_a)
			var body_b: Node = joint.get_node(joint.node_b)
			if body_a is RigidBody2D and body_a.has_method("set_connected_joint"):
				body_a.set_connected_joint(joint, body_b)
			if body_b is RigidBody2D and body_b.has_method("set_connected_joint"):
				if body_b.connected_joint == null:
					body_b.set_connected_joint(joint, body_a)
			if body_b is RigidBody2D and "limb_id" in body_b:
				_joint_map[body_b.limb_id] = joint


## ── Active balance ────────────────────────────────────────────────────

func _apply_balance(_delta: float) -> void:
	# ── Torso upright torque ───────────────────────────────────────────
	# Calculate how far the torso is from straight up.
	var angle_diff: float = _torso.rotation - target_angle
	while angle_diff > PI:
		angle_diff -= TAU
	while angle_diff < -PI:
		angle_diff += TAU

	# Strong corrective torque toward upright.
	var torque: float = -angle_diff * balance_torque
	# Damp existing spin so it doesn't oscillate.
	torque -= _torso.angular_velocity * angular_damping_force
	_torso.apply_torque(torque)

	# ── Height hold ────────────────────────────────────────────────────
	# Keep the torso at its spawn height so it doesn't sink or float.
	var height_error: float = _torso.global_position.y - _spawn_position.y
	if abs(height_error) > 2.0:
		# Negative height_error means torso is above spawn — push down.
		# Positive means below — push up.
		_torso.apply_central_force(Vector2.UP * -height_error * height_hold_force)

	# ── Leg support ────────────────────────────────────────────────────
	# Push lower legs upward to keep feet under the body.
	for limb_id in LEG_IDS:
		var leg: RigidBody2D = _limb_map.get(limb_id, null)
		if leg and not leg.freeze:
			# Apply upward force proportional to how far the leg has fallen.
			var leg_drop: float = leg.global_position.y - _spawn_position.y
			if leg_drop > 5.0:
				leg.apply_central_force(Vector2.UP * leg_support_force)


## ── Damage ────────────────────────────────────────────────────────────

func take_damage(amount: float, hit_position: Vector2) -> void:
	_apply_damage(amount, hit_position)


func _apply_damage(damage: float, hit_position: Vector2) -> void:
	if is_dead:
		return

	current_health = maxf(0.0, current_health - damage)
	health_changed.emit(current_health, max_health)
	_apply_hit_impulse(damage * 5.0, hit_position)

	if break_threshold > 0.0:
		_check_limb_breaks()

	if current_health <= 0.0:
		_die()


func _apply_hit_impulse(impulse: float, hit_position: Vector2) -> void:
	for part in _body_parts:
		if part.freeze:
			continue
		var direction: Vector2 = (part.global_position - hit_position).normalized()
		direction.y -= 0.3
		direction = direction.normalized()
		part.apply_central_impulse(direction * impulse)


func _check_limb_breaks() -> void:
	var hp_ratio: float = current_health / max_health
	for limb_id in _limb_map:
		var part: RigidBody2D = _limb_map[limb_id]
		if part.has_method("is_broken") and part.is_broken():
			continue
		if hp_ratio <= break_threshold:
			if part.has_method("break_joint"):
				part.break_joint()


## ── Death ──────────────────────────────────────────────────────────────

func _die() -> void:
	if is_dead:
		return
	is_dead = true
	active_balance = false
	died.emit()

	for limb_id in _limb_map:
		var part: RigidBody2D = _limb_map[limb_id]
		if part.has_method("break_joint"):
			part.break_joint()

	for part in _body_parts:
		if part.freeze:
			part.freeze = false
		var direction: Vector2 = (part.global_position - global_position).normalized()
		direction.y -= 1.0
		direction = direction.normalized()
		part.apply_central_impulse(direction * death_impulse)
		part.apply_torque_impulse(randf_range(-80.0, 80.0))


## ── Public helpers ─────────────────────────────────────────────────────

func get_body_parts() -> Array[RigidBody2D]:
	return _body_parts


func get_limb(limb_id: int) -> RigidBody2D:
	return _limb_map.get(limb_id, null)


func get_torso() -> RigidBody2D:
	return _torso


func unfreeze_all() -> void:
	for part in _body_parts:
		part.freeze = false


func freeze_all() -> void:
	for part in _body_parts:
		part.freeze = true
		part.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
