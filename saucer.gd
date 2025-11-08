extends Area2D

const SPEED = 400

var direction: Vector2
var offset: int = 75 # so the saucer can be entirely offscreen, magic number 
@onready var audio_stream_player_default: AudioStreamPlayer = $AudioStreamPlayerDefault

const EXPLOSION_PARTICLES = preload("res://explosion_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. 
func _process(delta: float) -> void:
	global_position += SPEED * direction * delta
	
	if (direction.x < 0 and global_position.x < -offset) or (direction.x > 0 and global_position.x > get_viewport_rect().size.x + offset):
		audio_stream_player_default.stop()
		direction = Vector2.ZERO

func _on_timer_timeout() -> void:
	global_position.y = [randf_range(0, 150), randf_range(get_viewport_rect().size.y - 150, get_viewport_rect().size.y)].pick_random()

	direction = Vector2([-1, 1].pick_random(),0)
	if direction.x < 0:
		global_position.x = get_viewport_rect().size.x + offset
	else:
		global_position.x = -offset
	
	audio_stream_player_default.play()
	
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		get_tree().current_scene.update_score(2000)
		
		# Spawn exposion here 
		var explosion_particle = EXPLOSION_PARTICLES.instantiate()
		explosion_particle.global_position = global_position
		explosion_particle.global_rotation = global_rotation
		get_tree().current_scene.add_child(explosion_particle)
		explosion_particle.play_large_explosion()
	
		body.queue_free()
		
		queue_free()
	
	if body.is_in_group("player"):
		body.die()
