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

	var target_pos = Vector3.ZERO  # Default position instead of null

	# Get Tom Nook's position
	var tom_nook = get_node_or_null("../Path3D/PathFollow3D/TomNook")
	if tom_nook != null:
		target_pos = tom_nook.global_position

	# Get the player's position
	var player = get_node_or_null("../Player")
	if player != null:
		target_pos = player.global_position

	# Add our global offset to the target position if we found either node
	if target_pos != Vector3.ZERO:
		global_position = target_pos + offset
