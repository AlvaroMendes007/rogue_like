extends CharacterBody2D

@export var speed: float = 3
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle: Marker2D = $Muzzle
@onready var timer_attack: Timer = $TimerAttack
@onready var timer_return: Timer = $TimerReturn

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_runnning: bool = false
var is_attacking: bool = false
var is_reloading: bool = false
var attack_cooldown: float = 2.0
var player_is_death: bool = false
var player_special_instance
@export var is_player_special: bool = false

@onready var healthbar: AnimatedSprite2D = $HealthBar

@export_category("ammo")
var current_ammo: int = 10
var max_ammo: int = 10

@export_category("life")
@export var life: int = 0
@export var max_life: int = 9

func _ready():
	life = max_life

func _process(delta: float) -> void:
	healthbar.frame = life
	
	if !player_is_death || !is_player_special:
		GameManager.player_position = position
		get_input()
		GameManager.flip_sprite(input_vector.x, $Sprite2D)
		if GameManager.player_xp >= 26:
			change_sprite("res://addons/Tech Dungeon Roguelite - Asset/Players/players blue x3.png")
			if Input.is_action_just_pressed("special_move"):
				if !is_player_special:
					instantiate_player_special()

func _physics_process(delta: float) -> void:
	if !player_is_death:
		set_player_velocity()
		move_and_slide()
		play_walk_idle_animation()

func get_input() -> void:
	var deadzone = 0.15
	
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", deadzone)
	if input_vector.x > 0:
		muzzle.position.x = 23
	elif input_vector.x < 0:
		muzzle.position.x = -23
	
	was_runnning = is_running
	is_running = not input_vector.is_zero_approx()

func attack() -> void:
	if is_attacking || player_is_death:
		return
		
	animation_player.play("shoot")
	
	attack_cooldown = 0.6
	is_attacking = true
	instantiate_bullet(is_player_special) 
	
func die():
	player_is_death = true
	animation_player.play("death")
	
func damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		die()

func play_walk_idle_animation():
	if not is_reloading:
		if was_runnning != is_running:
			if is_running:
				animation_player.play("walk")
			else:
				animation_player.play("idle")

func instantiate_player_special():
	var player_special_scene = load("res://player/player_super.tscn")       
	
	queue_free()
	if player_special_instance:
		player_special_instance.queue_free()
	player_special_instance = player_special_scene.instantiate()
	player_special_instance.position = global_position
	player_special_instance.life = life
	is_player_special = true
	
	var direction: Vector2 = input_vector.normalized() 
	get_parent().add_child(player_special_instance)
	timer_return.start()
	
func return_to_normal():
	var player_scene = load("res://player/player.tscn")    
	
	queue_free()
	var player_instance = player_scene.instantiate()
	player_instance.position = global_position
	player_instance.life = life
	is_player_special = false
	get_parent().add_child(player_instance)

func instantiate_bullet(is_player_special: bool):
	var bullet_scene = preload("res://scenes/bullet.tscn")       
	var bullet_instance = bullet_scene.instantiate()
	if is_player_special:
		bullet_instance.bullet_damage = 3
	
	bullet_instance.position = muzzle.global_position
	
	var direction: Vector2 = input_vector.normalized() 
	
	if muzzle.position.x < 0:
		direction.x -= 1
	if muzzle.position.x > 0:
		direction.x += 1
		
	if direction.y == 1:
		direction = Vector2.DOWN
	elif direction.y == -1:
		direction = Vector2.UP
		
	bullet_instance.rotation = direction.angle()
	
	get_parent().add_child(bullet_instance)
	is_attacking = false

func change_sprite(sprite_path: String) -> void:
	var new_texture = load(sprite_path)
	$Sprite2D.texture = new_texture

func set_player_velocity():
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)

func _on_timer_timeout():
	attack()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()


func _on_timer_return_timeout():
	return_to_normal()
