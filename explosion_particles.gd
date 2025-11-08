extends GPUParticles2D


@onready var explode_audio_stream_player_small: AudioStreamPlayer = $ExplodeAudioStreamPlayerSmall
@onready var explode_audio_stream_player_medium: AudioStreamPlayer = $ExplodeAudioStreamPlayerMedium
@onready var explode_audio_stream_player_large: AudioStreamPlayer = $ExplodeAudioStreamPlayerLarge
@onready var timer: Timer = $Timer


func _on_timer_timeout() -> void:
	queue_free()


func play_large_explosion() -> void:
	emitting = true
	timer.start()
	amount = 35
	explode_audio_stream_player_large.play()

func play_medium_explosion() -> void:
	emitting = true
	timer.start()
	amount = 30
	explode_audio_stream_player_medium.play()


func play_small_explosion() -> void:
	emitting = true
	timer.start()
	amount = 20
	explode_audio_stream_player_small.play()
