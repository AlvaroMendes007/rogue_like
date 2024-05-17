extends CharacterBody2D

@export var speed: float = 3
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var bullet_scene = preload("res://scenes/bullet.tscn")       

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_runnning: bool = false
var is_attacking: bool = false
var is_reloading: bool = false
var attack_cooldown: float = 0.0
var current_ammo: int = 10
var max_ammo: int = 10
var life: int = 0
var max_life: int = 20


func _process(delta: float) -> void:
	GameManager.player_position = position
	
	get_input()
	if Input.is_action_just_pressed("attack"):
		attack()
	update_attack_cooldown(delta)
	GameManager.flip_sprite(input_vector.x, $Sprite2D)	

func _physics_process(delta: float) -> void:
	set_player_velocity()
	move_and_slide()
	play_walk_idle_animation()

func get_input() -> void:
	var deadzone = 0.15
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", deadzone)
	
	was_runnning = is_running
	is_running = not input_vector.is_zero_approx()

func update_attack_cooldown(delta: float):
	if attack_cooldown > 0:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false

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
	get_parent().add_child(bullet_instance)
	
	bullet_instance.global_position = $Muzzle.global_position
	var direction = Vector2(1, 0).rotated(rotation)
	bullet_instance.rotation = direction.angle()
	bullet_instance.translate(direction * bullet_instance.speed)

func set_player_velocity():
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
