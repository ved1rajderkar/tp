extends Camera2D

## Smooth camera that follows a target (the player ragdoll's torso)
## with mouse-aware look-ahead.

@export var follow_speed: float = 5.0
@export var look_ahead: float = 80.0

var _target: Node2D = null


func set_target(target: Node2D) -> void:
	_target = target


func _process(delta: float) -> void:
	if _target == null:
		return

	var target_pos: Vector2 = _target.global_position

	# Pull the camera toward the mouse so you can see where you're aiming.
	var to_mouse: Vector2 = (get_global_mouse_position() - global_position).normalized()
	target_pos += to_mouse * look_ahead * 0.3

	global_position = global_position.lerp(target_pos, follow_speed * delta)
