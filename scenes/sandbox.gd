extends Node3D

const RADIUS = 11.156

@onready var camera: Camera3D = $Player/CameraMount/Camera3D
@onready var player: CharacterBody3D = $Player


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Disable the addon's camera
	camera.current = false

	# Override the addon's configuration
	player.enable_crouching = false
	player.enable_jumping = false
	player.enable_kicking = false
	player.enable_punching = false
	player.lock_camera = true
	player.lock_movement_y = true
	player.lock_perspective = true
	player.speed_running = 1.0
	player.speed_sprinting = 1.5


## Called during the physics processing step of the main loop.
func _physics_process(delta: float) -> void:

	# Get the input direction.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Handle vertical input (world rotation)
	if input_dir.y != 0:

		# Check if the player is not colliding with a wall
		if !player.is_on_wall():

			# Calculate the rotation angle based on input and speed.
			var angle = -(input_dir.y * player.speed_current * delta) / RADIUS

			# Rotate the world around the x-axis.
			$World.rotate_x(angle)
