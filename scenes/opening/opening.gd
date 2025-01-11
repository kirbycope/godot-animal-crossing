extends Node3D


func _input(event: InputEvent) -> void:
	# Check inputs
	if event.is_action("crouch") \
	or event.is_action("ui_select") \
	or event.is_action("start") \
	or event is InputEventScreenTouch:
		# Load new scene
		get_tree().change_scene_to_file("res://scenes/sandbox.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
