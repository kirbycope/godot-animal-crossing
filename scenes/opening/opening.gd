extends Node3D

@onready var voicebox: ACVoiceBox = $ACVoicebox
@onready var rover: CharacterBody3D = $Rover
@onready var rover_aninmation_player: AnimationPlayer = $Rover/AuxScene/AnimationPlayer
@onready var namebox: RichTextLabel = $Textbox/Name
@onready var textbox: RichTextLabel = $Textbox/Text
@onready var cursor: TextureRect = $Textbox/Cursor
@onready var train_camera: Camera3D = $TrainInt/Camera3D

var can_advance_dialog: bool = false
var current_dialog_index: int = -1
var dialog_hurried: bool = false
var dialog_sequence := [
	{
		"speaker": "Rover",
		"dialog": "Oh! Excuse me! I have a quick question for you.",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "It's now {hh}:{mm} {x}.m. on {MMMM} {dd}, {YYYY}, right?",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "I was right! Oh good! This watch of mine, it gets thrown off real easily sometimes!",
		"emote": "happy"
	},
	{
		"speaker": "Rover",
		"dialog": "...I'm just gonna plop down in the seat across from you. If you don't mind, of course!",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "By the way, you... Hold it! Can I ask your name?",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "Oh, {name}...? Well, that's a fantastically great name!",
		"emote": "happy"
	},
	{
		"speaker": "Rover",
		"dialog": "Yeah! You seem like a pretty cool guy to me!",
		"emote": "happy"
	},
	{
		"speaker": "Rover",
		"dialog": "So, {name}... Tell me, where are you headed today?",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "The town of {town_name}?",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "Hmmmm. {town_name}, yeah, Ok... Don't think I've heard of it. I wonder where it is.",
		"emote": "thinking"
	},
	{
		"speaker": "Rover",
		"dialog": "Oh, right! Map, map, map... Let's take a look along this train line... Ah, maybe this is it right here?",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "Heh. I'm glad we found it! This is {town_name} is it?",
		"emote": "happy"
	},
	{
		"speaker": "Rover",
		"dialog": "So do you get to go to {town_name} very often?",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "Oh, today is your first time? That sounds like tons of fun! Can I ask, why're you headed there?",
		"emote": "excited"
	},
	{
		"speaker": "Rover",
		"dialog": "What? Really?! Mya ha ha! I got it right on the first try!",
		"emote": "happy"
	},
	{
		"speaker": "Rover",
		"dialog": "Well now, moving into a new place! A whole new LIFE, even! You must be really excited, right?",
		"emote": "excited"
	},
	{
		"speaker": "Rover",
		"dialog": "I certainly hope you find happiness!",
		"emote": "happy"
	},
	{
		"speaker": "Speaker",
		"dialog": "Now arriving in {town_name}! {town_name} Station!",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "Oh, hey! Looks like we're about to arrive in {town_name}.",
		"emote": null
	},
	{
		"speaker": "Rover",
		"dialog": "Thanks for chatting with me! It's been a long time since I've enjoyed a train ride this much!",
		"emote": "happy"
	},
	{
		"speaker": "Rover",
		"dialog": "Come to think of it, I've been riding the rails an awful lot again lately.",
		"emote": "thinking"
	},
	{
		"speaker": "Rover",
		"dialog": "Haven't done this much traveling by train since 2002 or so... Man, that's weird.",
		"emote": "thinking"
	},
	{
		"speaker": "Rover",
		"dialog": "Okay, good luck, {name}! Bye-bye!",
		"emote": "happy"
	}
]
var look_at_rover: bool = false
var long_touch_timer: Timer
var movement_timer: Timer
var started: bool = false


## Called when there is an input event.
func _input(event: InputEvent) -> void:

	# Check if the event is a screen touch
	if event is InputEventScreenTouch:

		# Check if the event is a press
		if event.is_pressed():

			# Start the long touch timer
			long_touch_timer.start()

		# [touch] event _released_
		if event.is_released():

			# Stop the long touch timer
			long_touch_timer.stop()

			# If dialog was not hurried, try to advance dialog
			if !dialog_hurried:
				try_advance_dialog()
			else:
				dialog_hurried = false
				can_advance_dialog = true

	# [jump] button _pressed_
	if event.is_action_pressed("jump"):

		# Try to advance any open dialog
		try_advance_dialog()
	
	# [sprint] button _pressed_
	if event.is_action_pressed("sprint"):

		# Try to hurry the open dialog
		try_hurry_dialog()


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
	tween.parallel().tween_property($Textbox, "visible", true, 0.5)

	# Start the dialog
	tween.tween_callback(func():
		play_next_dialog()
	)


## Called during the processing step of the main loop.
func _process(_delta: float) -> void:

	# Look at Rover 1 second before they start moving.
	if !started and 0.9 >= movement_timer.time_left and movement_timer.time_left <= 1.0:
		started = true
		var tween = create_tween()
		tween.parallel().tween_property(train_camera, "rotation_degrees:x", -2, 0.8)
		tween.parallel().tween_property(train_camera, "rotation_degrees:y", -34, 0.8)

	# Check if the camera should be looking at Rover
	if look_at_rover:

		# Fix the camera to Rover's position
		train_camera.look_at(rover.global_position + Vector3(0.0, 0.2, 0.0))

	# Show the textbox cursor if the dialog can be advanced
	cursor.visible = can_advance_dialog


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Create and configure the movement timer
	movement_timer = Timer.new()
	movement_timer.one_shot = true
	movement_timer.wait_time = 2.0
	movement_timer.timeout.connect(_on_movement_timer_timeout)
	add_child(movement_timer)
	movement_timer.start()

	# Create and configure the long touch timer
	long_touch_timer = Timer.new()
	long_touch_timer.one_shot = true 
	long_touch_timer.wait_time = 0.5
	long_touch_timer.timeout.connect(_on_long_touch_timer_timeout)
	add_child(long_touch_timer)


## Called when the signal is emmitted for "done playing entire phrase".
func _on_ac_voicebox_finished_phrase() -> void:

	# Allow dialog advancement
	can_advance_dialog = true


## Called when the signal is emmitted for "done playing single sound".
func _on_ac_voicebox_characters_sounded(characters: Variant) -> void:
	textbox.text += characters


func _on_long_touch_timer_timeout() -> void:

	# If the dialog is currently being typed, hurry it
	if !can_advance_dialog and current_dialog_index < dialog_sequence.size():

		# Stop the voice
		voicebox.remaining_sounds = []
		voicebox.stop()
		dialog_hurried = true

		# Display full text immediately
		textbox.text = dialog_sequence[current_dialog_index].dialog


## Plays the next line in the dialog sequence.
func play_next_dialog() -> void:

	# Increment the dialog index
	current_dialog_index += 1

	# Check if there is more dialog to play
	if current_dialog_index < dialog_sequence.size():

		# Clear the textbox
		namebox.text = ""
		textbox.text = ""

		# Get the next dialog line
		var next_dialog = dialog_sequence[current_dialog_index]

		# Set the speaker's name
		namebox.text = "[center]" + next_dialog.speaker + "[/center]"

		# Start playing the dialog
		voicebox.play_string(next_dialog.dialog)

	else:

		# Load new scene
		get_tree().change_scene_to_file("res://scenes/sandbox.tscn")


## Attempts to advance the dialog if conditions are met.
func try_advance_dialog() -> void:

	# If the dialog is currently being typed, finish typing it
	if can_advance_dialog and current_dialog_index < dialog_sequence.size():

		# Reset flag
		can_advance_dialog = false

		# Play the next dialog
		play_next_dialog()


## Attempts to hurry the dialog if conditions are met.
func try_hurry_dialog() -> void:

	# If the dialog is currently being typed, finish typing it
	if !can_advance_dialog and current_dialog_index < dialog_sequence.size():

		# Stop the voice
		voicebox.remaining_sounds = []
		voicebox.stop()

		# Display full text immediately
		textbox.text = dialog_sequence[current_dialog_index].dialog

		# Allow immediate advancement
		can_advance_dialog = true
