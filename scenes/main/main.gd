extends Node3D


func _input(event: InputEvent) -> void:
	# Check inputs
	if event.is_action("crouch") \
	or event.is_action("ui_select") \
	or event.is_action("start") \
	or event is InputEventScreenTouch:
		# Load new scene
		get_tree().change_scene_to_file("res://scenes/opening/opening.tscn")


func _process(_delta: float) -> void:
	# Play walking animation
	var animation_player = $Path3D/PathFollow3D/TomNook/AnimationPlayer
	if animation_player.current_animation != "walking":
		animation_player.play("walking")
