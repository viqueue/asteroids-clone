extends Area2D

enum Size {
	LARGE = 0, 
	MEDIUM,
	SMALL
}

const SPEED = 200 
const LARGE_SIZE = 160 # sprite size large

var direction: Vector2
var current_size: Size = Size.LARGE

const EXPLOSION_PARTICLES = preload("res://explosion_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(current_size)
	var screen_size = get_viewport_rect().size
	match current_size:
		Size.LARGE:
			var x1 = randf_range(0, LARGE_SIZE)
			var x2 = randf_range(screen_size.x - LARGE_SIZE, screen_size.x)
			global_position.x = [x1, x2].pick_random()
			var y1 = randf_range(0, LARGE_SIZE)
			var y2 = randf_range(screen_size.y - LARGE_SIZE, screen_size.y)
			global_position.y = [y1, y2].pick_random()
			
			direction.x = randf_range(0, 1)
			direction.y = randf_range(0, 1)
			
			rotation = randf_range(0, TAU)

		Size.MEDIUM:
			# half the size
			scale = scale * 0.5
			# Random direction
		
			# Random rotation 
			
		Size.SMALL:
			pass
		_:
			print("Unknow: size")
	
	body_entered.connect(_on_body_entered)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = direction.normalized()
	global_position += direction * SPEED * delta
	
	var wrapping_margin = LARGE_SIZE / 2.0
	global_position.x = wrap(global_position.x, -wrapping_margin, get_viewport_rect().size.x + wrapping_margin)
	global_position.y = wrap(global_position.y, -wrapping_margin, get_viewport_rect().size.y + wrapping_margin)
	
	
func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.die()
	elif body.is_in_group("bullets"):
		body.queue_free()
		if current_size != Size.SMALL:
			for i in range(2):
				var asteroid_child = duplicate()
				# Need to set direction and rotation in _ready() afer this
				asteroid_child.global_position = global_position
				asteroid_child.global_rotation = global_rotation
				asteroid_child.direction = direction
				asteroid_child.current_size += 1
			
				get_parent().call_deferred("add_child", asteroid_child)
				
		_die()

func _die():
	var explosion_particle = EXPLOSION_PARTICLES.instantiate()
	explosion_particle.global_position = global_position
	explosion_particle.global_rotation = global_rotation
	explosion_particle.emitting = true
	get_tree().current_scene.add_child(explosion_particle)

	queue_free()
