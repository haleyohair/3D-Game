extends CharacterBody3D

var dying=false
var attacking=false



@onready var NA=$NavigationAgent3D
const SPEED=3.0
func _ready():
	$AnimationPlayer.play("Walk")

func _physics_process(_delta):
	var player = get_node_or_null("/root/Game/Player")
	if player != null and not dying and not attacking:
		look_at(player.global_position)
		NA.set_target_position(player.global_position)
		var current_position=global_position
		var next_position=NA.get_next_path_position()
		var new_velocity=(next_position- current_position).normalized()*SPEED
		velocity=new_velocity
		if !is_on_floor():
			velocity.y-=9.8
		else:
			velocity.y=0
	
	
	
	move_and_slide()


func _on_area_3d_body_entered(body):
	if not dying:
		attacking=true
		$AnimationPlayer.play("Attack")
		$Timer.start()

func _on_area_3d_body_exited(body):
	if not dying:
		attacking=false
		$AnimationPlayer.play("Walk")
		$Timer.stop()
		
func damage():
	if not dying:
		dying=true
		Global.update_score(100)
		$AnimationPlayer.play("Death")
		velocity=Vector3.ZERO
		
		


func _on_timer_timeout():
	for b in $Area3D.get_overlapping_bodies():
		if b.has_method("damage"):
			b.damage()


func _on_animation_player_animation_finished(Death):
	get_tree().change_scene_to_file("res://Good_End_Game.tscn")

