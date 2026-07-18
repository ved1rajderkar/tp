extends "res://scripts/ragdoll_target.gd"

## Player-controlled ragdoll archer.
## Extends RagdollTarget with bow aiming, trajectory preview, and arrow firing.
## The bow is a child of LowerArmR — it swings physically with the skeleton.

@export_group("Bow Settings")
## Drag to assign in Inspector, or leave empty to auto-load res://scenes/arrow.tscn.
@export var arrow_scene: PackedScene
@export var max_drag_distance: float = 200.0
@export var max_launch_speed: float = 1200.0
@export var min_drag_distance: float = 20.0

@export_group("Aim Line")
@export var aim_line_dots: int = 15
@export var aim_line_spacing: float = 12.0
@export var aim_line_color: Color = Color(1, 1, 1, 0.6)

## ── Internal ──────────────────────────────────────────────────────────
var _is_aiming: bool = false
var _drag_start: Vector2 = Vector2.ZERO
var _drag_current: Vector2 = Vector2.ZERO

var _bow_node: Node2D = null
var _aim_line: Line2D = null
var _lower_arm_r: RigidBody2D = null


func _ready() -> void:
	super._ready()
	_ensure_arrow_scene()
	_find_bow()
	_create_aim_line()


func _ensure_arrow_scene() -> void:
	if arrow_scene == null:
		arrow_scene = load("res://scenes/arrow.tscn")
		if arrow_scene == null:
			push_error("PlayerRagdoll: Could not load res://scenes/arrow.tscn")


func _find_bow() -> void:
	# Limb.LOWER_ARM_R == 5 (defined in ragdoll_body_part.gd)
	_lower_arm_r = get_limb(5)
	if _lower_arm_r == null:
		push_warning("PlayerRagdoll: LowerArmR not found!")
		return

	_bow_node = _lower_arm_r.get_node_or_null("Bow")
	if _bow_node == null:
		push_warning("PlayerRagdoll: Bow node not found on LowerArmR!")


func _create_aim_line() -> void:
	_aim_line = Line2D.new()
	_aim_line.width = 2.0
	_aim_line.default_color = aim_line_color
	_aim_line.visible = false
	add_child(_aim_line)


## ── Input ─────────────────────────────────────────────────────────────

func _unhandled_input(event: InputEvent) -> void:
	if is_dead:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_aim(event.position)
		else:
			_release_aim()
	elif event is InputEventMouseMotion and _is_aiming:
		_update_aim(event.position)


func _start_aim(mouse_pos: Vector2) -> void:
	_is_aiming = true
	_drag_start = mouse_pos
	_drag_current = mouse_pos
	if _aim_line:
		_aim_line.visible = true
		_aim_line.clear_points()


func _update_aim(mouse_pos: Vector2) -> void:
	_drag_current = mouse_pos
	_draw_aim_line()


func _release_aim() -> void:
	if not _is_aiming:
		return
	_is_aiming = false

	var drag_vector: Vector2 = _drag_current - _drag_start
	var drag_distance: float = drag_vector.length()

	if drag_distance >= min_drag_distance:
		_fire_arrow(drag_vector)

	if _aim_line:
		_aim_line.visible = false
		_aim_line.clear_points()


## ── Arrow firing ──────────────────────────────────────────────────────

func _fire_arrow(drag_vector: Vector2) -> void:
	if arrow_scene == null:
		push_warning("PlayerRagdoll: No arrow_scene — cannot fire!")
		return

	var arrow: RigidBody2D = arrow_scene.instantiate() as RigidBody2D
	if arrow == null:
		push_warning("PlayerRagdoll: Arrow scene did not produce a RigidBody2D!")
		return

	get_tree().current_scene.add_child(arrow)

	# Launch from the bow tip.
	arrow.global_position = _get_launch_position()

	var drag_distance: float = drag_vector.length()
	var power_ratio: float = clampf(drag_distance / max_drag_distance, 0.0, 1.0)
	var launch_speed: float = power_ratio * max_launch_speed
	# Inverted drag: pull back → shoot forward.
	var launch_direction: Vector2 = -drag_vector.normalized()

	arrow.launch(launch_direction, launch_speed)

	# Immediately align rotation to velocity so the arrow faces the right way.
	arrow.rotation = launch_direction.angle()

	# Kick the arm back for visual feedback.
	_apply_recoil(launch_direction, launch_speed * 0.15)


func _get_launch_position() -> Vector2:
	if _bow_node and _bow_node is Node2D:
		return _bow_node.global_position
	if _lower_arm_r:
		return _lower_arm_r.global_position
	return global_position


func _apply_recoil(direction: Vector2, force: float) -> void:
	if _lower_arm_r and not _lower_arm_r.freeze:
		_lower_arm_r.apply_central_impulse(direction * force * -1.0)
		_lower_arm_r.apply_torque_impulse(randf_range(-20.0, 20.0))


## ── Aim line drawing ──────────────────────────────────────────────────

func _draw_aim_line() -> void:
	if _aim_line == null:
		return
	_aim_line.clear_points()

	var drag_vector: Vector2 = _drag_current - _drag_start
	var drag_distance: float = drag_vector.length()
	if drag_distance < min_drag_distance:
		return

	var power_ratio: float = clampf(drag_distance / max_drag_distance, 0.0, 1.0)
	var launch_speed: float = power_ratio * max_launch_speed
	var launch_direction: Vector2 = -drag_vector.normalized()

	var sim_position: Vector2 = _get_launch_position()
	var sim_velocity: Vector2 = launch_direction * launch_speed
	var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", 980.0) * 0.3

	for i in range(aim_line_dots):
		_aim_line.add_point(sim_position - global_position)
		sim_velocity.y += gravity * (aim_line_spacing / launch_speed)
		sim_position += sim_velocity * (aim_line_spacing / launch_speed)
