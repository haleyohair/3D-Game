extends Node3D



func shoot():
	$Muzzle.show()
	$Timer.start()


func _on_timer_timeout():
	$Muzzle.hide()
