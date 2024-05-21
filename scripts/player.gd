extends CharacterBody2D

@export var speed: float = 3
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle: Marker2D = $Muzzle
@onready var timer_attack: Timer = $Timer
var bullet_scene = preload("res://scenes/bullet.tscn")       

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_runnning: bool = false
var is_attacking: bool = false
var is_reloading: bool = false
var attack_cooldown: float = 2.0
var current_ammo: int = 10
var max_ammo: int = 10
var life: int = 0
var max_life: int = 20

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	get_input()
	GameManager.flip_sprite(input_vector.x, $Sprite2D)	

func _physics_process(delta: float) -> void:
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
	if is_attacking:
		return
		
	animation_player.play("shoot")
	
	attack_cooldown = 0.6
	is_attacking = true
	
	instantiate_bullet() 

func play_walk_idle_animation():
	if not is_reloading:
		if was_runnning != is_running:
			if is_running:
				animation_player.play("walk")
			else:
				animation_player.play("idle")

func instantiate_bullet():
	var bullet_instance = bullet_scene.instantiate()
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

func set_player_velocity():
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)

func _on_timer_timeout():
	attack()
