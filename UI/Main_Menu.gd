extends Control

func _ready():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	

func _on_quit_pressed():
	get_tree().quit()



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
