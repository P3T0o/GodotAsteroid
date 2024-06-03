extends Node2D
class_name Level


@onready var gameover : Control = %GameOver
@onready var border_rect = %BorderRect
@onready var asteroids_container : Node2D = %Asteroids
@onready var score_label : Label = %ValeurPoints
var screen_with = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var screen_size = Vector2(screen_with, screen_height)

var score = 0

@export var asteroid_scene : PackedScene
@export var spawn_circle_radius = 580.0
@export var asteroid_direction_variance = 45.0

func _ready():
	update_score_label()

func spawn_asteroid_on_border():
	var screen_center = screen_size / 2.0
	var angle = deg_to_rad(randf_range(0.0, 360.0))
	var dir_to_point = Vector2.RIGHT.rotated(angle)
	var point = screen_center + dir_to_point * spawn_circle_radius
	
	var top_left = border_rect.global_position
	var bottom_right = border_rect.global_position + border_rect.size
	
	point = point.clamp(top_left, bottom_right)
	
	var dir_to_center = point.direction_to(screen_center)
	
	var dir_rotation = randfn(0.0, deg_to_rad(asteroid_direction_variance))
	var asteroid_dir = dir_to_center.rotated(dir_rotation)
	var asteroid_size = randi_range(0, Asteroid.SIZE.size() - 1)
	spawn_asteroid(point, asteroid_dir, asteroid_size)
	
	

func spawn_asteroid(pos: Vector2, dir: Vector2, size: Asteroid.SIZE):
	var asteroid = asteroid_scene.instantiate()
	asteroids_container.add_child.call_deferred(asteroid)
	
	asteroid.direction = dir
	asteroid.position = pos
	
	asteroid.size = size
	asteroid.destroyed.connect(_on_asteroid_destroyed.bind(asteroid))


func _on_asteroid_destroyed(asteroid: Asteroid):
	if asteroid.size > 0:
		var nb_spawn = randi_range(2, 3)
		add_points(1)
		
		for i in range(nb_spawn):
			var rot_deg = 90.0 + randfn(0.0, deg_to_rad(asteroid_direction_variance))
			var rdm_sign = [-1, 1].pick_random()
			var rot = deg_to_rad(rot_deg * rdm_sign)
			
			var dir = asteroid.direction.rotated(rot)
			
			spawn_asteroid(asteroid.global_position, dir, asteroid.size -1)

# Fonction pour mettre à jour le label avec le score actuel
func update_score_label():
	score_label.text = "SCORE: " + str(score)

# Fonction pour ajouter des points au score
func add_points(points: int):
	score += points
	update_score_label()

func _on_spawn_timer_timeout():
	spawn_asteroid_on_border()


func _on_button_pressed():
	get_tree().reload_current_scene()


func _on_player_destroyed():
	gameover.show()
