extends PathFollow3D

@export var isForward:bool = false
@export var isStart:bool = true
@export var current_tack:Node3D
@export var isFinish:bool = false
@export var isDone:bool = false
@export var speed:float = 0.09
#@onready var conveyor_belt: Path3D = $"../conveyor_belt"

func _ready() -> void:
	attach_track()
	#pass

func _process(delta: float) -> void:
	
	if current_tack:
		if isForward:
			if isDone == false:
				progress += speed * delta
				if progress >= 0.84:
					isDone=true
					check_new_path()
		else:
			#print("progress:", progress)
			if isDone == false:
				progress -= speed * delta
				if progress <= 0.01:
					print("progress: >>>>>>>")
					isDone=true
					check_new_path()

func check_new_path():
	if current_tack:
		if isForward:
			if current_tack.TrackForward:
				current_tack = current_tack.TrackForward
				attach_track() #reparent track from path
				set_forward(true) #set path follow
		else:
			if current_tack.TrackBackward:
				current_tack = current_tack.TrackBackward
				attach_track() #reparent track from path
				set_forward(false) #set path follow
				#print("progress:", progress)
			#pass
	#pass

func set_forward(_isforward):
	isForward = _isforward
	if _isforward:
		#progress = 0.0
		set_progress(0.0)
	else:
		print("backward...")
		#progress = 1
		set_progress(1.0)# required not progress since going negtive is not set correctly.
		#await get_tree().create_timer(100).timeout
		#progress = 1
	isDone = false

func attach_track()->void:
	if current_tack:
		#current_tack.add_child(self)
		#reparent(current_tack, true)
		get_parent().call_deferred("remove_child", self)
		current_tack.call_deferred("add_child", self)
	#pass
# 
