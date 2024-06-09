extends CharacterBody2D

class_name Player

@onready var audio_fire : AudioStreamPlayer = $AudioFire
@onready var audio_destroy : AudioStreamPlayer2D = $AudioDestroy
@onready var animated_weapon : AnimatedSprite2D = $AnimatedWeapon

@export_range(0.0, 1.0) var accel_factor : float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor : float = 0.1

@export var projectile_scene: PackedScene

@export var max_speed : float = 200.0
var speed : float = 0.0

var can_fire = true
var fire_rate = 0.2  # Temps en secondes entre chaque tir
var time_since_last_fire = 0

var direction := Vector2.ZERO
var last_direction := Vector2.ZERO

signal projectile_fired(projectile)
signal destroyed

var projectile

func _ready() -> void:
	animated_weapon.frame_changed.connect(_on_frame_changed)


func _physics_process(delta: float) -> void:
	move()
	rotate_toward_move()
	
	# Mettre à jour le temps écoulé depuis le dernier tir
	time_since_last_fire += delta
	
	if Input.is_action_pressed("fire") and can_fire:
		if time_since_last_fire >= fire_rate:
			fire()
			time_since_last_fire = 0


func _input(event: InputEvent) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		last_direction = direction

	if event.is_action_pressed("fire"):
		fire()

func fire() -> void:
	animated_weapon.play()

func _on_frame_changed():
	print("Frame changée: ", animated_weapon.frame)
	if animated_weapon.frame == 6:
		projectile = projectile_scene.instantiate()
		projectile.global_transform = global_transform
		audio_fire.play()
		projectile_fired.emit(projectile)


func move() -> void:
	# Move the ship
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)
	else:
		speed = lerp(speed, max_speed, accel_factor)
	
	velocity = last_direction * speed
	move_and_slide()

func rotate_toward_move() -> void:
	# Rotate the ship toward the mouse
	var mouse_pos = get_global_mouse_position()
	var angle = global_position.angle_to_point(mouse_pos)
	rotation = lerp_angle(rotation, angle, rotation_accel_factor)
	
func destroy() -> void:
	destroyed.emit()
	queue_free()
	
