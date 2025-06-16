extends CharacterBody3D

@export var main:Node3D
@export var placeholder:Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	attach_track()
	pass

func _unhandled_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	pass

func attach_track()->void:
	if main:
		print("reparent?")
		#current_tack.add_child(self)
		#reparent(current_tack, true)
		placeholder.get_parent().call_deferred("remove_child", placeholder)
		main.call_deferred("add_child", placeholder)
	#pass
