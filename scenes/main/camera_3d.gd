extends Camera3D

# Store the initial transform and offset
var initial_basis: Basis
var offset: Vector3

func _ready():
	# Store the initial global orientation
	initial_basis = global_transform.basis
	
	# Calculate the initial offset in global coordinates
	offset = Vector3(0, 0.95, 1)  # 1 meter back

func _process(_delta):
	# Get parent's (TomNook's) position
	var target_pos = get_parent().global_position
	
	# Add our global offset to the target position
	global_position = target_pos + offset
	
	# Keep the original orientation
	global_transform.basis = initial_basis
