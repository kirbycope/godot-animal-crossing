extends Node3D

@onready var voicebox: ACVoiceBox = $ACVoicebox
@onready var rover: CharacterBody3D = $Rover
@onready var rover_aninmation_player: AnimationPlayer = $Rover/AuxScene/AnimationPlayer
@onready var textbox: RichTextLabel = $Textbox/Text
@onready var train_camera: Camera3D = $TrainInt/Camera3D

var can_change_scene := false
var look_at_rover := false
var movement_timer: Timer
var started := false


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

	# Have the camera look at Rover
	look_at_rover = true

	# Start "walking" animation
	rover_aninmation_player.get_animation("Walking_In_Place").loop_mode = Animation.LOOP_LINEAR
	rover_aninmation_player.play("Walking_In_Place")

	# Create tween for smooth movement
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)

	# Set up initial movement
	var start_pos = rover.position
	var end_pos = start_pos + Vector3(0.0, -0.1, 0.1)

	# Perform movement sequence
	tween.parallel().tween_property(rover, "rotation_degrees:x", 0, 0.2)
	tween.parallel().tween_property(rover, "rotation_degrees:y", 90, 0.5)
	tween.parallel().tween_property(rover, "position", end_pos, 0.5)

	# Create an interval (causing the previous tweens to run before continuing
	tween.tween_interval(0.0)

	# Perform movement sequence
	end_pos = end_pos + Vector3(-0.4, 0.0, 0.0)
	tween.tween_property(rover, "position", end_pos, 1.0)

	# Create an interval (causing the previous tweens to run before continuing
	tween.tween_interval(0.0)

	# Perform movement sequence
	end_pos = end_pos + Vector3(0.0, 0.0, 0.55)
	tween.parallel().tween_property(rover, "rotation_degrees:y", 180, 0.5)
	tween.parallel().tween_property(rover, "position", end_pos, 2.0)

	# Create an interval (causing the previous tweens to run before continuing
	tween.tween_interval(0.0)

	# Perform movement sequence
	end_pos = end_pos + Vector3(-0.35, 0.0, 0.0)
	tween.parallel().tween_property(rover, "rotation_degrees:y", 90, 0.5)
	tween.parallel().tween_property(rover, "position", end_pos, 1.0)

	# Create an interval (causing the previous tweens to run before continuing
	tween.tween_interval(0.0)

	# When "walking" is complete, play "sitting" animation
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

	# Start the dialog
	tween.tween_callback(func():
		var dialog = "Oh! Excuse me! I have a quick question for you."
		#textbox.text = dialog
		textbox.start_typing(dialog)
		voicebox.play_string(dialog)
	)


## Timer completion callback
func _on_timer_timeout() -> void:

	# Enable scene change
	can_change_scene = true


func _process(delta: float) -> void:
	
	if !started and 0.9 >= movement_timer.time_left and movement_timer.time_left <= 1.0:
		started = true
		var tween = create_tween()
		tween.parallel().tween_property(train_camera, "rotation_degrees:x", -2, 0.8)
		tween.parallel().tween_property(train_camera, "rotation_degrees:y", -34, 0.8)

	if look_at_rover:
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


func _on_ac_voicebox_finished_phrase() -> void:
	print("Done yappin'")


func _on_ac_voicebox_characters_sounded(characters: Variant) -> void:
	pass # Replace with function body.
