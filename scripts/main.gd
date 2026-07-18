extends Node2D

## Main game scene. Sets up player ragdoll archer, targets, camera, and ground.

@onready var _camera: Camera2D = $Camera2D


func _ready() -> void:
	# Find the player ragdoll and wire the camera to its torso.
	var player: Node = $PlayerRagdoll
	if player and player.has_method("get_torso"):
		var torso: Node2D = player.get_torso()
		if torso and _camera:
			_camera.set_target(torso)

	# Connect death signals for respawn logic.
	_setup_ragdoll_signals()


func _setup_ragdoll_signals() -> void:
	for child in get_children():
		if child.has_signal("died") and child != $PlayerRagdoll:
			child.died.connect(_on_ragdoll_died.bind(child))


func _on_ragdoll_died(ragdoll: Node) -> void:
	get_tree().create_timer(3.0).timeout.connect(_respawn_ragdoll.bind(ragdoll))


func _respawn_ragdoll(old_ragdoll: Node) -> void:
	var scene: PackedScene = load("res://scenes/ragdoll_target.tscn")
	if scene == null:
		return
	var new_ragdoll: Node2D = scene.instantiate()
	new_ragdoll.global_position = old_ragdoll.global_position
	new_ragdoll.global_position.x += randf_range(-80.0, 80.0)
	add_child(new_ragdoll)
	old_ragdoll.queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
