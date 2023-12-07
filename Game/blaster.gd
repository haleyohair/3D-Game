extends Node3D



func shoot():
	$Muzzle.show()
	$Timer.start()
	if $Aim.is_colliding():
		var target=$Aim.get_collider()
		if target.has_method("damage"):
			target.damage()


func _on_timer_timeout():
	$Muzzle.hide()
