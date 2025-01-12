extends Node3D

# Create a timer variable
var can_change_scene := false


func _input(event: InputEvent) -> void:

	# Only allow scene change after timer is done and input received
	if can_change_scene:

		# Check inputs
		if event.is_action("crouch") \
		or event.is_action("ui_select") \
		or event.is_action("start") \
		or event is InputEventScreenTouch:

			# Load new scene
			get_tree().change_scene_to_file("res://scenes/opening/opening.tscn")


## Timer completion callback
func _on_timer_timeout() -> void:

	# Enable scene change
	can_change_scene = true


## Called during the processing step of the main loop.
func _process(_delta: float) -> void:

	# Play walking animation
	var animation_player = $Path3D/PathFollow3D/TomNook/AnimationPlayer
	if animation_player.current_animation != "walking":
		animation_player.play("walking")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Create and configure the timer
	var timer := Timer.new()
	timer.one_shot = true  
	timer.wait_time = 3.0
	timer.timeout.connect(_on_timer_timeout)

	# Add the timer to _this_ scene
	add_child(timer)

	# Start the timer
	timer.start()
