extends Node
class_name StateMachine

# Constants
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const CROUCH_SPEED = 2.5
const CROUCH_HEIGHT_SCALE = 0.5
const CROUCH_RADIUS_SCALE = 0.5

# Node references
@onready var player_body: CharacterBody3D = get_parent()
@onready var collision_shape: CollisionShape3D = player_body.get_node("CollisionShape3D")
@onready var mesh_instance: MeshInstance3D = player_body.get_node("MeshInstance3D")
@onready var neck: Node3D = player_body.get_node("neck")
@onready var camera: Camera3D = neck.get_node("Camera3D")

@export var isController: bool = false

# State nodes
@onready var idle: Node = $idle
@onready var walk: Node = $walk
@onready var jump: Node = $jump
@onready var crouch: Node = $crouch
@onready var sprint: Node = $sprint
@onready var fall: Node = $fall

var current_state: Node = null
var previous_state: Node = null

# Stored original properties
var original_shape_height: float
var original_shape_radius: float
var original_mesh_position: Vector3
var original_neck_position: Vector3
var original_position_y: float
var is_crouching: bool = false
var is_sprinting: bool = false

func _ready() -> void:
	# Initialize original properties
	if collision_shape and collision_shape.shape is CapsuleShape3D:
		original_shape_height = collision_shape.shape.height
		original_shape_radius = collision_shape.shape.radius
		print("Original height:", original_shape_height, "Original radius:", original_shape_radius)
	else:
		push_error("CollisionShape3D must have a CapsuleShape3D assigned.")
	if mesh_instance:
		original_mesh_position = mesh_instance.position
	else:
		push_error("MeshInstance3D not found.")
	if neck:
		original_neck_position = neck.position
	original_position_y = player_body.position.y
	
	# Set initial state
	current_state = idle
	if current_state.has_method("_enter_state"):
		current_state._enter_state()

func _unhandled_input(event: InputEvent) -> void:
	if !isController:
		return
	
	# Mouse controls
	#if event is InputEventMouseButton:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#elif event.is_action_pressed("ui_cancel"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			player_body.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(80), deg_to_rad(90))
	
	# Route input to current state
	if current_state.has_method("_unhandled_input"):
		current_state._unhandled_input(event)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not player_body.is_on_floor():
		player_body.velocity += player_body.get_gravity() * delta
	
	# Route state-specific physics
	if current_state.has_method("_node_physics_process"):
		var new_state = current_state._node_physics_process(delta)
		if new_state and new_state != current_state:
			change_state(new_state)
	
	# Global state transitions
	if not player_body.is_on_floor() and current_state != jump and current_state != fall and current_state != crouch:
		change_state(fall)
	elif player_body.is_on_floor() and current_state == fall:
		change_state(idle)
	
	player_body.move_and_slide()

func change_state(new_state: Node) -> void:
	if new_state == current_state:
		return
	
	#print("Changing state from ", current_state.name, " to ", new_state.name)
	
	# Exit current state
	if current_state.has_method("_exit_state"):
		current_state._exit_state()
	
	previous_state = current_state
	current_state = new_state
	
	# Enter new state
	if current_state.has_method("_enter_state"):
		current_state._enter_state()
