extends Node3D

var Bullet_Hole=preload("res://Game/bullet_hole.tscn")
var Dropped_Blaster=preload("res://Game/Dropped_Blaster.tscn")


func shoot():
	$Muzzle.show()
	$Timer.start()
	$Sound.play()
	if $Aim.is_colliding():
		var target=$Aim.get_collider()
		var bullet_hole=Bullet_Hole.instantiate()
		target.add_child(bullet_hole)
		bullet_hole.global_position=$Aim.get_collision_point()
		if $Aim.get_collision_normal()==Vector3.UP:
			bullet_hole.look_at($Aim.get_collision_normal()+$Aim.get_collision_point(),Vector3.RIGHT)
		else:
			bullet_hole.look_at($Aim.get_collision_normal()+$Aim.get_collision_point(),Vector3.UP)
		if target.has_method("damage"):
			target.damage()


func _on_timer_timeout():
	$Muzzle.hide()
	
func drop():
	var game=get_node_or_null("/root/Game")
	if game!=null:
		var dropped_blaster=Dropped_Blaster.instantiate()
		game.add_child(dropped_blaster)
		dropped_blaster.global_position=global_position+ Vector3(0,1,-1)
		dropped_blaster.linear_velocity=Vector3(0, 1, -2)
		queue_free()
