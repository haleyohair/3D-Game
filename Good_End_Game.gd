extends Control



func _ready():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Label.text="You Win!\n Final Score: " + str(Global.score)
func _on_play_again_pressed():
	Global.reset()
	get_tree().change_scene_to_file("res://game.tscn")

func _on_quit_pressed():
	get_tree().quit()
