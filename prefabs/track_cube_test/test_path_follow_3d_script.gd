extends PathFollow3D
# https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html
# strange bug that when going backward there is position clipping

@export var isForward:bool = false
@export var isStart:bool = true
@export var current_tack:Node3D
@export var isFinish:bool = false
@export var isDone:bool = false
@export var speed:float = 0.09
#@onready var conveyor_belt: Path3D = $"../conveyor_belt"
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

@export var isCheckValue:bool = true

func _ready() -> void:
	attach_track()
	#pass

func _process(delta: float) -> void:
	print("progress:", progress, " progress_ratio:", progress_ratio)
	if current_tack:
		if isForward:
			if isDone == false:
				progress += speed * delta
				update_face_direction()
				if progress >= 1.0 or progress_ratio >= 1.0:
					isDone=true
					check_new_path()
		else:
			#print("progress:", progress)
			if isCheckValue == false:
				#if get_progress_ratio() <= 0.90:
				#print(" progress_ratio ===============:", progress_ratio)
				#visible = false
				set_progress_ratio(1.0)
				if get_progress_ratio() == 1.0:
					isCheckValue = true
					visible = true
				pass
			
			if isDone == false and isCheckValue == true:
				progress -= speed * delta
				update_face_direction()
				if progress <= 0.00 or progress_ratio <= 0.00:
					isDone=true
					isCheckValue=false
					set_progress_ratio(1.0)
					check_new_path()
	#update_face_direction()

func check_new_path():
	if current_tack:
		if isForward:
			if current_tack.TrackForward:
				current_tack = current_tack.TrackForward
				attach_track() #reparent track from path
				set_forward(true) #set path follow
		else:
			if current_tack.TrackBackward:
				visible = false
				current_tack = current_tack.TrackBackward
				attach_track() #reparent track from path
				set_forward(false) #set path follow
				#print("progress:", progress)
				#set_progress_ratio(1.0)
			#pass
	#pass

func set_forward(_isforward):
	isForward = _isforward
	if _isforward:
		set_progress(0.0)
	else:
		#print("backward...")
		#set_progress(1.0)
		#set_progress_ratio(1.0) # required not progress is not set correctly.
		print(" progress_ratio>>>>>>>>>>>:", progress_ratio)
		if get_progress_ratio() <= 0.90:
			visible = false
		pass
	isDone = false

func attach_track()->void:
	if current_tack:
		#current_tack.add_child(self)
		#reparent(current_tack, true)
		get_parent().call_deferred("remove_child", self)
		current_tack.call_deferred("add_child", self)
	#pass

#mesh test face dir
func update_face_direction(is_face:bool = true):
	if current_tack:
		var basis = Basis()
		var curve = current_tack.curve as Curve3D
		var up = curve.sample_baked_up_vector(progress, true)
		var forward
		#forward = position.direction_to(curve.sample_baked(progress + 0.1, true))
		if is_face:
			forward = position.direction_to(curve.sample_baked(progress + 0.1, true))
		else:
			forward = position.direction_to(curve.sample_baked(progress - 0.1, true))
		basis.y = up
		basis.x = forward.cross(up).normalized()
		basis.z = -forward
		
		var _transform = Transform3D(basis, position)
		self.transform = _transform
		#self.transform = transform.interpolate_with(_transform, 0.5)
		
		
		
