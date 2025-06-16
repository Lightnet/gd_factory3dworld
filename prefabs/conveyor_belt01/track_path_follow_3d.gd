#@tool
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
		var _basis = Basis()
		var curve = path3d.curve as Curve3D
		var up = curve.sample_baked_up_vector(progress, true)
		var forward = position.direction_to(curve.sample_baked(progress + 0.01, true))
		
		_basis.y = up
		_basis.x = forward.cross(up).normalized()
		_basis.z = -forward
		
		var _transform = Transform3D(_basis, position)
		self.transform = _transform
	#pass
