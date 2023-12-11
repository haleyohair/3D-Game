extends Node

var score=0
var time=130


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
	
func _input(event):
	if event.is_action_pressed("menu"):
		var menu = get_node_or_null("/root/Game/UI/Menu")
		if menu == null:
			get_tree().quit()
		else:
			if menu.hidden:
				menu.show()
				get_tree().paused = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				menu.hide()
				get_tree().paused = false
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var agent=get_node_or_null("/root/Game/Agent")
	if agent != null :
		if agent.get_child_count()==0:
			get_tree().change_scene_to_file("res://UI/end_game.tscn")

func update_score(s):
	score+=s
	var hud= get_node_or_null("/root/Game/UI/HUD")
	if hud!=null:
		hud.update_score()
		
func update_time(t):
	time+=t
	
func reset():
	score=0
	time=130
		


	



