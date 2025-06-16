extends CenterContainer

@export var radius:float = 1.0
@export var color:Color =  Color.WHITE

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _draw() -> void:
	draw_circle(Vector2(0,0), radius, color)
	#pass
