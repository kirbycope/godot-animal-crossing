extends Node

@onready var player: CharacterBody3D = get_parent().get_parent()


## Called when there is an input event.
func _input(event: InputEvent) -> void:

	# Check if the game is not paused
	if !Globals.game_paused:

		# [crouch] button just _released_
		if Input.is_action_just_released("crouch"):

			# Start "standing"
			to_standing()

		# [jump] button just _pressed_
		if Input.is_action_just_pressed("jump"):

			# Start "jumping"
			to_jumping()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	# Check if the player is not moving
	if player.velocity == Vector3(0.0, 0.0, 0.0):

		# Start "crouching"		
		to_crouching()

	# Check if the player is "crawling"
	if player.is_crawling:

		# Play the animation
		play_animation()


## Plays the appropriate animation based on player state.
func play_animation() -> void:

	# Check if the animation player is not locked
	if !player.is_animation_locked:

		# Check if the player is "holding a rifle"
		if player.is_holding_rifle:

			# Check if the animation player is not already playing the appropriate animation
			if player.animation_player.current_animation != player.animation_crouching_move_holding_rifle:

				# Play the "crouching and moving, holding a rifle" animation
				player.animation_player.play(player.animation_crouching_move_holding_rifle, -1, 0.75)

		# The player must be unarmed
		else:

			# Check if the animation player is not already playing the appropriate animation
			if player.animation_player.current_animation != player.animation_crawling:

				# Play the "crawling" animation
				player.animation_player.play(player.animation_crawling)


## Start "crawling".
func start() -> void:

	# Enable _this_ state node
	process_mode = PROCESS_MODE_INHERIT

	# Set the player's new state
	States.current_state = States.State.CRAWLING

	# Flag the player as "crawling"
	player.is_crawling = true

	# Set the player's movement speed
	player.speed_current = player.speed_crawling

	# Set CollisionShape3D height
	player.get_node("CollisionShape3D").shape.height = player.collision_height / 2

	# Set CollisionShape3D position
	player.get_node("CollisionShape3D").position = player.collision_position / 2


## Stop "crawling".
func stop() -> void:

	# Disable _this_ state node
	process_mode = PROCESS_MODE_DISABLED

	# Flag the player as not "crawling"
	player.is_crawling = false

	# Reset CollisionShape3D height
	player.get_node("CollisionShape3D").shape.height = player.collision_height

	# Reset CollisionShape3D position
	player.get_node("CollisionShape3D").position = player.collision_position


## State.CRAWLING -> State.CROUCHING
func to_crouching():

	# Stop "crawling"
	stop()

	# Start "crouching"
	$"../Crouching".start()


## State.CRAWLING -> State.JUMPING
func to_jumping():

	# Stop "crawling"
	stop()

	# Start "jumping"
	$"../Jumping".start()


## State.CRAWLING -> State.STANDING
func to_standing():

	# Stop "crawling"
	stop()

	# Start "standing"
	$"../Standing".start()