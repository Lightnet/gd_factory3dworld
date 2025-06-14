extends PathFollow3D

@export var speed:float = 0.09
@export var isForward:bool = false
@export var isDone:bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	#progress += speed * delta
	print("progress:", progress)
	if isForward:
		if isDone == false:
			progress += speed * delta
			if progress > 0.84:
				isDone=true
	else:
		if isDone == false:
			progress -= speed * delta
			if progress < 0.01:
				isDone=true
	#pass

func set_forward(_isforward):
	isForward = _isforward
	isDone = false
	if _isforward:
		progress = 0.0
	else:
		progress = 1.0
