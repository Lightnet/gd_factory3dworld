extends Node

@onready var state_machine: StateMachine = get_parent()

func _enter_state() -> void:
	pass  # Play idle animation here

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and state_machine.player_body.is_on_floor():
		state_machine.change_state(state_machine.jump)
	if event.is_action_pressed("crouch"):
		state_machine.change_state(state_machine.crouch)
	if event.is_action_pressed("sprint") and state_machine.player_body.is_on_floor():
		state_machine.change_state(state_machine.sprint)

func _node_physics_process(_delta: float) -> Node:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (state_machine.player_body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	state_machine.player_body.velocity.x = move_toward(state_machine.player_body.velocity.x, 0, state_machine.WALK_SPEED)
	state_machine.player_body.velocity.z = move_toward(state_machine.player_body.velocity.z, 0, state_machine.WALK_SPEED)
	
	if direction and state_machine.player_body.is_on_floor():
		if Input.is_action_pressed("sprint"):
			return state_machine.sprint
		return state_machine.walk
	return null
