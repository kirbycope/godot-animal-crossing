extends Node3D

@onready var camera: Camera3D = $Player/CameraMount/Camera3D
@onready var player: CharacterBody3D = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Disable the addon's camera
	camera.current = false

	# Override the addon's configuration
	player.enable_crouching = false
	player.enable_jumping = false
	player.enable_kicking = false
	player.enable_punching = false
	player.lock_camera = true
	player.lock_perspective = true
	player.speed_running = 1.0
	player.speed_sprinting = 1.5
