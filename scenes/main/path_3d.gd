extends Path3D


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_speed = 0.5
	get_node("PathFollow3D").progress += delta * move_speed
	if $PathFollow3D/TomNook/AnimationPlayer.current_animation != "walking":
		$PathFollow3D/TomNook/AnimationPlayer.play("walking")
	#$"../CameraMount".global_position = $PathFollow3D/TomNook.global_position
