extends Node

const MESHPOINTER = preload("res://prefabs/meshpointer/meshpointer_3d.tscn")
@onready var conveyor: Path3D = $"../../conveyor"

@export var isBuild:bool = true
@onready var ray_cast_3d: RayCast3D = $"../../neck/Camera3D/RayCast3D"
@export var hitPos:Vector3
@export var points:Array[Vector3]
@export var mesh_points:Array[Node3D]

func _ready() -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and event.is_pressed():
		print("LEFT MOUSE")
		
		var tmp_point = MESHPOINTER.instantiate()
		tmp_point.position = hitPos
		get_tree().current_scene.add_child(tmp_point)
		mesh_points.append(tmp_point)
		
		points.append(hitPos)
		print("points lens:", len(points))
		hitPos.y =hitPos.y + 1.0
		conveyor.curve.add_point(
			hitPos,
			Vector3.ZERO,
			Vector3.ZERO,
			-1
		)
		
	if Input.is_action_just_pressed("build_clear") and event.is_pressed():
		print("clear points")
		points.clear() # clear array
		for node in mesh_points:
			node.queue_free()
		mesh_points.clear()
		
		#pass
	#pass

func _process(delta: float) -> void:
	update_point_position()
	pass

func update_point_position():
	if ray_cast_3d.is_colliding():
		#print("hit...")
		hitPos = ray_cast_3d.get_collision_point()
		#print("hit pos:", hitPos)
	pass
