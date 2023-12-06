extends Node3D



func _shoot():
	$Muzzle.show()
	$Timer.start()


func _on_timer_timeout():
	$Muzzle.hide()
