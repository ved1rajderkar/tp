extends Node2D

## Slingshot-style bow controller.
## Click and drag backward from the player to aim, release to fire an arrow.
## The drag direction is inverted: pulling back launches forward.

@export_group("Bow Settings")
## Scene to instantiate for each arrow.
@export var arrow_scene: PackedScene
## Maximum drag distance in pixels (caps the launch power).
@export var max_drag_distance: float = 200.0
## Maximum launch speed.
@export var max_launch_speed: float = 1200.0
## Minimum drag distance before an arrow can be fired.
@export var min_drag_distance: float = 20.0

@export_group("Aim Line")
## Number of dots in the trajectory preview.
@export var aim_line_dots: int = 15
## Spacing between trajectory preview dots.
@export var aim_line_spacing: float = 12.0
## Color of the aim line.
@export var aim_line_color: Color = Color(1, 1, 1, 0.6)

var _is_aiming: bool = false
var _drag_start: Vector2 = Vector2.ZERO
var _drag_current: Vector2 = Vector2.ZERO

@onready var _aim_line: Line2D = $AimLine
@onready var _player_body: CharacterBody2D = $PlayerBody


func _ready() -> void:
	if _aim_line:
		_aim_line.visible = false
		_aim_line.default_color = aim_line_color


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
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
	_update_aim_line()


func _release_aim() -> void:
	if not _is_aiming:
		return
	_is_aiming = false

	var drag_vector := _drag_current - _drag_start
	var drag_distance := drag_vector.length()

	if drag_distance >= min_drag_distance:
		_fire_arrow(drag_vector)

	if _aim_line:
		_aim_line.visible = false
		_aim_line.clear_points()


func _fire_arrow(drag_vector: Vector2) -> void:
	if not arrow_scene:
		push_warning("BowController: No arrow_scene assigned!")
		return

	var arrow: RigidBody2D = arrow_scene.instantiate()
	get_tree().current_scene.add_child(arrow)

	# Position the arrow at the player's launch point
	arrow.global_position = _player_body.global_position

	# Calculate launch velocity: inverted drag direction, clamped to max
	var drag_distance := drag_vector.length()
	var power_ratio := clampf(drag_distance / max_drag_distance, 0.0, 1.0)
	var launch_speed := power_ratio * max_launch_speed

	# The launch direction is OPPOSITE to the drag (pull back = shoot forward)
	var launch_direction := -drag_vector.normalized()

	arrow.launch(launch_direction, launch_speed)


func _update_aim_line() -> void:
	if not _aim_line:
		return

	_aim_line.clear_points()

	var drag_vector := _drag_current - _drag_start
	var drag_distance := drag_vector.length()

	if drag_distance < min_drag_distance:
		return

	var power_ratio := clampf(drag_distance / max_drag_distance, 0.0, 1.0)
	var launch_speed := power_ratio * max_launch_speed
	var launch_direction := -drag_vector.normalized()

	# Simulate the trajectory with a simple projectile arc
	var arrow_position := _player_body.global_position
	var arrow_velocity := launch_direction * launch_speed
	var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", 980.0) * 0.3

	for i in range(aim_line_dots):
		_aim_line.add_point(arrow_position - global_position)
		# Simulate physics step
		arrow_velocity.y += gravity * (aim_line_spacing / launch_speed)
		arrow_position += arrow_velocity * (aim_line_spacing / launch_speed)


func get_aim_direction() -> Vector2:
	if not _is_aiming:
		return Vector2.RIGHT
	var drag_vector := _drag_current - _drag_start
	if drag_vector.length() < min_drag_distance:
		return Vector2.RIGHT
	return -drag_vector.normalized()


func get_power_ratio() -> float:
	if not _is_aiming:
		return 0.0
	var drag_vector := _drag_current - _drag_start
	return clampf(drag_vector.length() / max_drag_distance, 0.0, 1.0)


func is_aiming() -> bool:
	return _is_aiming
