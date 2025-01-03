extends Node3D


func _input(event: InputEvent) -> void:
	if event.is_action("crouch") or event.is_action("ui_select") or event.is_action("start"):
		# Load new scene
		get_tree().change_scene_to_file("res://scenes/sandbox.tscn")


func _process(delta: float) -> void:
	var animation_player = $Path3D/PathFollow3D/TomNook/AnimationPlayer
	if animation_player.current_animation != "walking":
		animation_player.play("walking")
