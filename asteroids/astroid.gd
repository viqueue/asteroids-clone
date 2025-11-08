extends Area2D

enum Size {
	LARGE = 0, 
	MEDIUM,
	SMALL
}

const LARGE_SIZE = 160 # sprite size large

var direction: Vector2
var speed := 220

const EXPLOSION_PARTICLES = preload("res://explosion_particles.tscn")

var main # not the best idead

@export var current_size: Size = Size.LARGE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().current_scene
	
	var screen_size = get_viewport_rect().size
	if current_size == Size.LARGE:
		var x1 = randf_range(0, LARGE_SIZE)
		var x2 = randf_range(screen_size.x - LARGE_SIZE, screen_size.x)
		global_position.x = [x1, x2].pick_random()
		var y1 = randf_range(0, LARGE_SIZE)
		var y2 = randf_range(screen_size.y - LARGE_SIZE, screen_size.y)
		global_position.y = [y1, y2].pick_random()
			
		direction.x = randf_range(0, 1)
		direction.y = randf_range(0, 1)
		
		rotation = randf_range(0, TAU)
	else:
		scale = scale * 0.6
		
	body_entered.connect(_on_body_entered)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = direction.normalized()
	global_position += direction * speed * delta
	
	var wrapping_margin = LARGE_SIZE / 2.0
	global_position.x = wrap(global_position.x, -wrapping_margin, get_viewport_rect().size.x + wrapping_margin)
	global_position.y = wrap(global_position.y, -wrapping_margin, get_viewport_rect().size.y + wrapping_margin)
	
	
func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.die()
		_die() # nah
	elif body.is_in_group("bullets"):
		body.queue_free()
		
		if current_size != Size.SMALL:
			for i in range(2):
				var asteroid_child = duplicate()
				asteroid_child.global_position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
				asteroid_child.global_rotation = randf_range(0, PI)
				asteroid_child.direction = Vector2.RIGHT.rotated(direction.angle() + randf_range(-PI/4, PI/4))
				asteroid_child.current_size = current_size + 1 
				asteroid_child.speed = speed * (1 + randf_range(0.1, 0.2))
				
				get_parent().call_deferred("add_child", asteroid_child)
								
		_die()

func _die():
	var explosion_particle = EXPLOSION_PARTICLES.instantiate()
	explosion_particle.global_position = global_position
	explosion_particle.global_rotation = global_rotation

	get_tree().current_scene.add_child(explosion_particle)
	if current_size == Size.LARGE:
		main.update_score(20)
		explosion_particle.play_large_explosion()
	elif current_size == Size.MEDIUM:
		main.update_score(50)
		explosion_particle.play_medium_explosion()
	elif current_size == Size.SMALL:
		main.update_score(100)
		explosion_particle.play_small_explosion()
	
	queue_free()
