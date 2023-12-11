extends Control

func _ready():
	update_score()
	update_time()
	
func update_score():
	$Score.text = "Score " + str(Global.score)

func update_time():
	$Time.text="Time: " + str(Global.time)

func _on_timer_timeout():
	Global.update_time(-1)
	update_time()
	if Global.time<=0:
		get_tree().change_scene_to_file("res://UI/end_game.tscn")
