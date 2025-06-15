extends CharacterBody3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _unhandled_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	pass
