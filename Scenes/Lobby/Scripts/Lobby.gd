extends Control
class_name Lobby


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_button_play_pressed():
	change_scene("res://Scenes/Level/Level.tscn")

func change_scene(scene_path: String) -> void:
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		print("Erreur lors du changement de scène : %s" % str(error))


func _on_button_exit_pressed():
	get_tree().quit()
