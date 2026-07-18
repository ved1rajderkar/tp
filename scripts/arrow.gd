extends RigidBody2D

## Arrow projectile launched by the player.
## Rotates to face its velocity vector and sticks into targets on collision.

const STUCK_Z_INDEX := 10

var _stuck_to: Node2D = null
var _stuck_offset: Vector2 = Vector2.ZERO
var _stuck_rotation: float = 0.0

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)
	gravity_scale = 0.3


func _physics_process(_delta: float) -> void:
	if _stuck_to:
		# Follow the parent node we're stuck to
		global_position = _stuck_to.global_position + _stuck_offset
		global_rotation = _stuck_to.global_rotation + _stuck_rotation
		return

	# Rotate to face velocity direction for realistic flight
	if linear_velocity.length_squared() > 100.0:
		rotation = linear_velocity.angle()


func launch(direction: Vector2, speed: float) -> void:
	var dir: Vector2 = direction.normalized()
	linear_velocity = dir * speed
	rotation = dir.angle()
	gravity_scale = 0.3


func _on_body_entered(body: Node2D) -> void:
	if _stuck_to:
		return

	# Check if the body has a take_damage method (ragdoll parts)
	if body.has_method("take_damage"):
		var damage := _calculate_damage(body)
		body.take_damage(damage, global_position)

	_stick_to_body(body)


func _stick_to_body(body: Node2D) -> void:
	_stuck_to = body
	# Calculate offset relative to the stuck body
	_stuck_offset = global_position - body.global_position
	_stuck_rotation = global_rotation - body.global_rotation

	# Freeze physics so the arrow doesn't fly around
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	contact_monitor = false
	collision_layer = 0
	collision_mask = 0
	z_index = STUCK_Z_INDEX


func _calculate_damage(body: Node2D) -> float:
	# Body parts should define a damage_multiplier property
	if body.get("damage_multiplier") != null:
		return body.damage_multiplier
	return 1.0
