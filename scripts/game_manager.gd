extends Node

signal game_over

var player: Player
var player_position: Vector2
var player_xp: int = 0
var is_player_special: bool = false
var is_game_over: bool = false

var time_elapsed: float = 0.0
var time_elapsed_string: String
var enemies_defeated: int = 0

var ammo: int = 0
var max_ammo: int = 10

func _process(delta: float):
	time_elapsed += delta
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	time_elapsed_string = "%02d:%02d" % [minutes, seconds]

func flip_sprite(input_vector_x: float, sprite_2d: Sprite2D):
	if input_vector_x > 0:
		sprite_2d.flip_h = false
		pass
	if input_vector_x < 0:
		sprite_2d.flip_h = true
		
func flip_sprite_animated_sprite(input_vector_x: float, animated_sprite_2d: AnimatedSprite2D):
	if input_vector_x > 0:
		animated_sprite_2d.flip_h = false
		pass
	if input_vector_x < 0:
		animated_sprite_2d.flip_h = true

func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	
	time_elapsed = 0.0
	time_elapsed_string = ""
	enemies_defeated = 0
	max_ammo = 10
	ammo = max_ammo
	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
		
func defeatEnemy():
	enemies_defeated += 1
