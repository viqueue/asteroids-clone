extends GPUParticles2D

@onready var explode_audio_stream_player: AudioStreamPlayer = $ExplodeAudioStreamPlayer


func _ready() -> void:
	explode_audio_stream_player.play()

func _on_timer_timeout() -> void:
	queue_free()
