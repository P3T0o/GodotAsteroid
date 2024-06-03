@tool
extends Area2D
class_name Asteroid

var direction := Vector2.RIGHT

enum SIZE {
	SMALL,
	MEDIUM,
	BIG
}
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var size : SIZE = SIZE.BIG:
	set(value):
		if value != size:
			size = value
			size_changed.emit()

@export var speed : float = 200.0
@export var torque = 50.0

@export var asteroid_size_array : Array[AsteroidSize]

signal size_changed
signal destroyed

func _ready():
	if Engine.is_editor_hint():
		set_physics_process(false)
	
	size_changed.connect(update_size)
	update_size()
	

func _physics_process(delta):
	var velocity = speed * direction * delta
	global_position += velocity
	rotation_degrees += torque * delta

func update_size():
	if not size in range(asteroid_size_array.size()):
		push_error("the given size "+ str(size) +" value ins't a valid asteroid size index")
	
	var asteroid_size = asteroid_size_array[size]
	
	sprite.texture = asteroid_size.texture
	collision_shape.shape = asteroid_size.shape
	
func destroy():
	destroyed.emit()
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.destroy()
