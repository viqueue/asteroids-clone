extends Node2D

const MAIN_SCENE = preload("res://main.tscn")

const ASTEROID_01 = preload("res://asteroids/asteroid_01.tscn")
const ASTEROID_02 = preload("res://asteroids/asteroid_02.tscn")
const ASTEROID_03 = preload("res://asteroids/asteroid_03.tscn")
var astroid_scenes = [ASTEROID_01, ASTEROID_02, ASTEROID_03]



@onready var asteroids: Node2D = $Asteroids

@export var num_asteroids :int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_rect:Vector2 = get_viewport_rect().size
	for i in range(num_asteroids):
		var asteroid = astroid_scenes.pick_random().instantiate()
		asteroid.global_position.x =  randf_range(0, viewport_rect.x)
		asteroid.global_position.y = randf_range(0, viewport_rect.y)
		
		asteroid.rotation = randf_range(0, TAU)
		
		asteroid.direction = Vector2(randf_range(0, 1), randf_range(0, 1)).normalized()
		
		asteroid.current_size = [asteroid.Size.SMALL, asteroid.Size.MEDIUM, asteroid.Size.LARGE].pick_random()
		
		asteroids.add_child(asteroid)



func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE)
	
