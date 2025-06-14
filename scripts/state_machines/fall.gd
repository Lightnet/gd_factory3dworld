extends Node

@onready var state_machine: StateMachine = get_parent()

func _enter_state() -> void:
	pass  # Play fall animation here

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("crouch"):
		state_machine.change_state(state_machine.crouch)

func _node_physics_process(_delta: float) -> Node:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (state_machine.player_body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		state_machine.player_body.velocity.x = direction.x * state_machine.WALK_SPEED
		state_machine.player_body.velocity.z = direction.z * state_machine.WALK_SPEED
	return null
