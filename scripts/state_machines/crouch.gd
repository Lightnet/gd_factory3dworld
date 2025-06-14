extends Node

@onready var state_machine: StateMachine = get_parent()

func _enter_state() -> void:
	if state_machine.collision_shape and state_machine.collision_shape.shape is CapsuleShape3D:
		state_machine.collision_shape.shape.height = state_machine.original_shape_height * state_machine.CROUCH_HEIGHT_SCALE
		state_machine.collision_shape.shape.radius = state_machine.original_shape_radius * state_machine.CROUCH_RADIUS_SCALE
		var height_difference = (state_machine.original_shape_height - state_machine.collision_shape.shape.height) / 2.0
		state_machine.player_body.position.y -= height_difference
		if state_machine.mesh_instance:
			state_machine.mesh_instance.position.y = state_machine.original_mesh_position.y * state_machine.CROUCH_HEIGHT_SCALE
		if state_machine.neck:
			state_machine.neck.position.y = state_machine.original_neck_position.y * state_machine.CROUCH_HEIGHT_SCALE
		print("Crouch height:", state_machine.collision_shape.shape.height, "Crouch radius:", state_machine.collision_shape.shape.radius)
	state_machine.is_crouching = true
	# Play crouch animation here

func _exit_state() -> void:
	if state_machine.collision_shape and state_machine.collision_shape.shape is CapsuleShape3D:
		state_machine.collision_shape.shape.height = state_machine.original_shape_height
		state_machine.collision_shape.shape.radius = state_machine.original_shape_radius
		if state_machine.mesh_instance:
			state_machine.mesh_instance.position = state_machine.original_mesh_position
		if state_machine.neck:
			state_machine.neck.position = state_machine.original_neck_position
		state_machine.player_body.position.y = state_machine.original_position_y
	state_machine.is_crouching = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("crouch"):
		state_machine.change_state(state_machine.idle)
	if event.is_action_pressed("jump") and state_machine.player_body.is_on_floor():
		state_machine.change_state(state_machine.jump)

func _node_physics_process(_delta: float) -> Node:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (state_machine.player_body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		state_machine.player_body.velocity.x = direction.x * state_machine.CROUCH_SPEED
		state_machine.player_body.velocity.z = direction.z * state_machine.CROUCH_SPEED
	else:
		state_machine.player_body.velocity.x = move_toward(state_machine.player_body.velocity.x, 0, state_machine.CROUCH_SPEED)
		state_machine.player_body.velocity.z = move_toward(state_machine.player_body.velocity.z, 0, state_machine.CROUCH_SPEED)
	return null
