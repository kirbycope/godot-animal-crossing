extends Camera3D

# Store the initial transform and offset
var initial_basis: Basis
var offset: Vector3
var current_pos: Vector3  # Track current position for lerping

# Adjust this value to control smoothing (0.0 to 1.0)
@export var smoothing: float = 0.05

func _ready():
	# Store the initial global orientation
	initial_basis = global_transform.basis
	
	# Calculate the initial offset in global coordinates
	offset = Vector3(0, 0.95, 1)  # 1 meter back
	
	# Initialize current position to starting position
	current_pos = global_position

func _process(delta: float) -> void:
	# Get parent's (TomNook's) position
	var target_pos = get_parent().global_position
	
	# Calculate desired position with offset
	var desired_pos = target_pos + offset
	
	# Smoothly interpolate to the target position
	current_pos = current_pos.lerp(desired_pos, smoothing)
	global_position = current_pos

	# Keep the original orientation
	global_transform.basis = initial_basis
