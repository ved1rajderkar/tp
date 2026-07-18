extends RigidBody2D

## Individual ragdoll body part with limb identification, damage multipliers,
## and the ability to break its connecting joint on fatal damage.

## ── Limb identification ──────────────────────────────────────────────
## Used by the parent ragdoll to map joints to body parts.
enum Limb { HEAD, TORSO, UPPER_ARM_L, LOWER_ARM_L, UPPER_ARM_R, LOWER_ARM_R,
			UPPER_LEG_L, LOWER_LEG_L, UPPER_LEG_R, LOWER_LEG_R }

@export var limb_id: Limb = Limb.TORSO

## ── Damage ────────────────────────────────────────────────────────────
@export var damage_multiplier: float = 1.0
@export var hit_color: Color = Color.RED

## ── Joint reference ───────────────────────────────────────────────────
## The PinJoint2D that connects this limb to its parent body.
## Set automatically by RagdollTarget._register_parts().
var connected_joint: PinJoint2D = null
## The other body this limb is joined to (for joint breaking).
var connected_body: RigidBody2D = null

## ── Internal state ────────────────────────────────────────────────────
var _ragdoll_target: Node = null
var _original_color: Color
var _hit_timer: float = 0.0
var _is_broken: bool = false

@onready var _visual: CanvasItem = _find_visual_node()


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	if _visual:
		_original_color = _visual.modulate


func _process(delta: float) -> void:
	if _hit_timer > 0.0:
		_hit_timer -= delta
		if _hit_timer <= 0.0 and _visual:
			_visual.modulate = _original_color


## Called by RagdollTarget to wire up the reference.
func setup(target: Node) -> void:
	_ragdoll_target = target


## Called by RagdollTarget to link the joint that connects this limb.
func set_connected_joint(joint: PinJoint2D, other_body: RigidBody2D) -> void:
	connected_joint = joint
	connected_body = other_body


## ── Damage entry point ───────────────────────────────────────────────
func take_damage(amount: float, hit_position: Vector2) -> void:
	var final_damage: float = amount * damage_multiplier
	_ragdoll_target._apply_damage(final_damage, hit_position)
	_flash_hit()


## Break this limb off by removing its joint entirely.
## Returns true if a joint was actually broken.
func break_joint() -> bool:
	if _is_broken or connected_joint == null:
		return false
	_is_broken = true

	# Disable collision between this limb and the body it was connected to,
	# so they can freely separate instead of catching on each other.
	if connected_body:
		set_collision_mask_value(connected_body.collision_layer, false)
		# Clear the joint reference on the other body too.
		if "connected_joint" in connected_body and connected_body.connected_joint == connected_joint:
			connected_body.connected_joint = null

	connected_joint.queue_free()
	connected_joint = null
	connected_body = null
	return true


func is_broken() -> bool:
	return _is_broken


## ── Visual feedback ──────────────────────────────────────────────────
func _flash_hit() -> void:
	_hit_timer = 0.15
	if _visual:
		_visual.modulate = hit_color


func _find_visual_node() -> CanvasItem:
	for child in get_children():
		if child is CanvasItem and child != self:
			return child
	return null
