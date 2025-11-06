extends CharacterBody2D

const SPEED = 750

var rot: float
var dir: Vector2
var pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	global_rotation = rot


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += dir * SPEED * delta
	
	global_position.x = wrapf(global_position.x, 0, get_viewport_rect().size.x)
	global_position.y = wrapf(global_position.y, 0, get_viewport_rect().size.y)
	


func _on_timer_timeout() -> void:
	queue_free()
	
	
