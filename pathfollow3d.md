# pathfollow3d

# Information:
    This is just notes.

    You need to set set_progress_ratio function call since progress can't be set at 1.0 float.

    But you can use progress variable to do normal speed counter add.

    Try to set progress = 1.0 result was reject. When doing next path3d.

    Since there was min and max for progress or some internal restricted set.

    The begin or end will cause the transform rotate in correctly due to default format settings. The editor looks normal but in game test it bug out rotate when near either points.

	Forward code works and smooth direction. But the backward direction strange bug skiping 1.0 to 0.80 which not suspose to do. Not there are clipping when move next path since it not snap.

	Backward move I guess might not update render? As fixed position clip from begin or end points.

	It seem not snyc in frame update to update the varialbe.

# script:
```gdscript
extends PathFollow3D

@export var speed:float = 0.09
@export var isForward:bool = false
@export var isDone:bool = false
@export var isSetValue:bool = false
@onready var path3d: Path3D = $".."

#func _ready() -> void:
	#pass

func _process(delta: float) -> void:
	#progress += speed * delta
	print("progress:", progress, " isSetValue: ",isSetValue)
	if isForward:
		if isDone == false:
			progress += speed * delta
			if progress > 0.84 or progress_ratio >= 1.0:
				isDone=true
				set_forward(true)
	else:
		if isDone == false:
			progress -= speed * delta
			#update_transform()
			#basis = basis.orthonormalized()
			update_face_direction()
			if progress <= 0.01 or progress_ratio <= 0.01:
				isDone=true
				set_forward(false)
	#pass
func update_progress():
	#progress = 0.9
	#set_progress(0.99)
	set_progress_ratio(1.0)
	pass

func set_forward(_isforward):
	isForward = _isforward
	
	if _isforward:
		#progress = 0.0
		#set_progress(0.0)
		set_progress_ratio(0.0)
	else:
		#progress = 1.1
		#set_progress(1.1)
		set_progress_ratio(1.0)
	isDone = false
	
func update_face_direction():
	if path3d:
		var basis = Basis()
		var curve = path3d.curve as Curve3D
		var up = curve.sample_baked_up_vector(progress, true)
		var forward = position.direction_to(curve.sample_baked(progress + 0.01, true))
		
		basis.y = up
		basis.x = forward.cross(up).normalized()
		basis.z = -forward
		
		var transform = Transform3D(basis, position)
		self.transform = transform
	#pass

```