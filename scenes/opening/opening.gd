extends Node3D

@onready var rover: CharacterBody3D = $Rover
@onready var rover_aninmation_player: AnimationPlayer = $Rover/AuxScene/AnimationPlayer
@onready var train_camera: Camera3D = $TrainInt/Camera3D

# Create a timer variable
var can_change_scene := false
var movement_timer: Timer


## Called when there is an input event.
func _input(event: InputEvent) -> void:

	# Only allow scene change after timer is done and input received
	if can_change_scene:

		# Check inputs
		if event.is_action("crouch") \
		or event.is_action("ui_select") \
		or event.is_action("start") \
		or event is InputEventScreenTouch:

			# Load new scene
			get_tree().change_scene_to_file("res://scenes/sandbox.tscn")


## Movement timer completion callback
func _on_movement_timer_timeout() -> void:

	# Start walking animation
	rover_aninmation_player.get_animation("Walking_In_Place").loop_mode = Animation.LOOP_LINEAR
	rover_aninmation_player.play("Walking_In_Place")

	# Create tween for smooth movement
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)

	# Set up initial movement
	var start_pos = rover.position
	var end_pos = start_pos + Vector3(0.0, -0.1, 0.1)

	# Perform movement sequence
	tween.parallel().tween_property(rover, "rotation_degrees:x", 0, 0.2)
	tween.parallel().tween_property(rover, "rotation_degrees:y", 90, 0.5)
	tween.parallel().tween_property(rover, "position", end_pos, 0.5)

	# Wait 0.5 seconds
	tween.tween_interval(0.5)

	# Perform movement sequence
	end_pos = end_pos + Vector3(-0.4, 0.0, 0.0)
	tween.tween_property(rover, "position", end_pos, 1.0)

	# Wait 1.0 seconds
	tween.tween_interval(0.5)

	# Perform movement sequence
	end_pos = end_pos + Vector3(0.0, 0.0, 0.55)
	tween.parallel().tween_property(rover, "rotation_degrees:y", 180, 0.5)
	tween.parallel().tween_property(rover, "position", end_pos, 2.0)

	# Wait 2.0 seconds
	tween.tween_interval(0.5)

	# Perform movement sequence
	end_pos = end_pos + Vector3(-0.35, 0.0, 0.0)
	tween.parallel().tween_property(rover, "rotation_degrees:y", 90, 0.5)
	tween.parallel().tween_property(rover, "position", end_pos, 1.0)

	# Wait 1.0 seconds
	tween.tween_interval(0.5)

	# When movement is complete, play standing animation
	tween.tween_callback(func():
		rover_aninmation_player.stop()
		rover_aninmation_player.play("Sitting")
	)

	# Perform movement sequence
	end_pos = end_pos + Vector3(0.0, 0.1, 0.0)
	tween.parallel().tween_property(rover, "rotation_degrees:x", 15, 0.1)
	tween.parallel().tween_property(rover, "rotation_degrees:y", 195, 0.1)
	tween.parallel().tween_property(rover, "position", end_pos, 0.1)
	tween.parallel().tween_property($Textbox, "visible", true, 0.7)


## Timer completion callback
func _on_timer_timeout() -> void:

	# Enable scene change
	can_change_scene = true


func _process(delta: float) -> void:
	train_camera.look_at(rover.global_position + Vector3(0.0, 0.2, 0.0))


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Create and configure the scene change timer
	var timer := Timer.new()
	timer.one_shot = true  
	timer.wait_time = 3.0
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

	# Create and configure the movement timer
	movement_timer = Timer.new()
	movement_timer.one_shot = true
	movement_timer.wait_time = 2.0
	movement_timer.timeout.connect(_on_movement_timer_timeout)
	add_child(movement_timer)
	movement_timer.start()
