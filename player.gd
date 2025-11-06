extends CharacterBody2D

const BULLET = preload("res://bullet.tscn")

const SPEED = 5
const ROTATTION_SPEED = 4 # rad/s
const DAMPING = 0.75
const MAX_SPEED = 2000

@onready var animated_sprite: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var gun_position: Node2D = $GunPosition
@onready var shoot_audio_stream_player: AudioStreamPlayer = $SFX/ShootAudioStreamPlayer
@onready var thrust_audio_stream_player: AudioStreamPlayer = $SFX/ThrustAudioStreamPlayer


@export var  explosion_particle_scn: PackedScene


func _ready() -> void:
	global_position = get_viewport_rect().size / 2


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("thrust"):
		var direction: Vector2 = transform.x
		direction = direction.normalized()
		velocity += direction * SPEED
		velocity = velocity.limit_length(MAX_SPEED)
		animated_sprite.play("thrust")
		thrust_audio_stream_player.stream_paused = false
	else:
		velocity *= 0.97
		animated_sprite.stop()
		thrust_audio_stream_player.stream_paused = true
	
	if Input.is_action_pressed("rotate_left"):
		rotation -= ROTATTION_SPEED * delta
	if Input.is_action_pressed("rotate_right"):
		rotation += ROTATTION_SPEED * delta
	
	if Input.is_action_just_pressed("shoot"):
		_shoot()
	
	var collision = move_and_collide(velocity * delta)
	if collision:

		var collider = collision.get_collider()
		if collider.is_in_group("asteroids"):
			queue_free()
	
	
	# Wrap
	global_position.x = wrapf(global_position.x, 0, get_viewport_rect().size.x)
	global_position.y = wrapf(global_position.y, 0, get_viewport_rect().size.y)
	
 
func _shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.pos = gun_position.global_position
	bullet.rot = global_rotation
	bullet.dir = global_transform.x
	
	get_parent().add_child(bullet)
	shoot_audio_stream_player.play()
	

func die() -> void:
	# Spawn exposion here 
	var explosion_particle = explosion_particle_scn.instantiate()
	explosion_particle.global_position = global_position
	explosion_particle.global_rotation = global_rotation
	explosion_particle.emitting = true
	get_tree().current_scene.add_child(explosion_particle)

	queue_free()
