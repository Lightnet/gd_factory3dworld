extends Area3D

@export var next_segment: NodePath
@export var belt_speed: float = 2.0
@export var belt_direction: Vector3 = Vector3(0, 0, -1)

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is RigidBody3D:
			body.linear_velocity = belt_direction * belt_speed
			if next_segment:
				var next = get_node(next_segment)
				if next and body.position.distance_to(next.global_position) < 0.5:
					# Transition to next segment’s direction
					body.linear_velocity = next.belt_direction * next.belt_speed
