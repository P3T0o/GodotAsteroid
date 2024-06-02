extends Node2D

@export var speed : float = 400.0

@onready var direction := Vector2.RIGHT.rotated(rotation)

func _physics_process(delta: float) -> void:
	var velocity = direction * speed * delta
	global_position += velocity
