extends Node2D


const PLAYER_MAX_LIVES = 3

var player_curr_lives: int = 0

const PLAYER = preload("res://player.tscn")

var blink_duraton := 2
var blink_interval := 0.15


@onready var life_1: TextureRect = $GUI/Lives/Life1
@onready var life_2: TextureRect = $GUI/Lives/Life2
@onready var life_3: TextureRect = $GUI/Lives/Life3
@onready var score_labal: RichTextLabel = $GUI/RichTextLabel
@onready var game_over: Control = $GUI/GameOver

var current_score: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over.hide()
	
	_spawn_player(true)
	player_curr_lives = PLAYER_MAX_LIVES


func _spawn_player(first_time: bool = false) -> void:
	var player = PLAYER.instantiate()
	player.global_position = get_viewport_rect().size / 2.0
	call_deferred("add_child", player)
	player.player_died.connect(_on_Player_died)
	if not first_time:
		_player_blink(player)
	

func _on_Player_died() -> void:
	player_curr_lives -= 1
	if player_curr_lives == 2:
		life_3.visible = false
	elif  player_curr_lives == 1:
		life_2.visible = false
	elif  player_curr_lives == 0:
		life_1.visible = false
		game_over.show()
		
	if player_curr_lives > 0:
		_spawn_player()
	

func _player_blink(player: CharacterBody2D) -> void:
	var end_time = Time.get_ticks_msec() + int(blink_duraton * 1000)
	while Time.get_ticks_msec() < end_time:
		if is_instance_valid(player):
			player.disable_collision()
			player.visible = not player.visible
			await get_tree().create_timer(blink_interval).timeout
			
	if is_instance_valid(player):
		player.enable_collision()
		player.visible = true
	
func update_score(score: int) -> void:
	current_score += score
	score_labal.text = "Score: " + str(current_score) 


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_try_again_pressed() -> void:
	get_tree().reload_current_scene()
