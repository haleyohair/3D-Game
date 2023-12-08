extends CharacterBody3D

@onready var head=$head
@onready var standing_collsion_shape=$standing_collsion_shape
@onready var crouching_collsion_shape=$crouching_collsion_shape
@onready var ray_cast_3d=$RayCast3D
@onready var anim_player=$AnimationPlayer

var health=5
var current_speed = 5.0

const walking_speed=5.0
const sprinting_speed=12.0
const crouching_speed=3.0
const jump_velocity = 4.5

const mouse_sens=0.25

var direction= Vector3.ZERO
var lerp_speed=10.0

var crouching_depth=-.5

var can_drop=true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))
		head.rotation.x=clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))
	
func _physics_process(delta):
	if Input.is_action_just_pressed("pickup") and can_drop:
		for w in $head/Weapon.get_children():
			if w.has_method("drop"):
				w.drop()
				
	if Input.is_action_just_pressed("shoot"):
		var weapons=$head/Weapon
		for w in weapons.get_children():
			if w.has_method("shoot"):
				w.shoot()
		
	if Input.is_action_pressed("crouch"):
		current_speed=crouching_speed
		head.position.y=lerp(head.position.y,1.8+crouching_depth,delta*lerp_speed)
		standing_collsion_shape.disabled=true
		crouching_collsion_shape.disabled=false
	elif !ray_cast_3d.is_colliding():
		standing_collsion_shape.disabled=false
		crouching_collsion_shape.disabled=true
		head.position.y=lerp(head.position.y,1.8,delta*lerp_speed)
		if Input.is_action_pressed("sprint"):
			current_speed=sprinting_speed
		else:
			current_speed=walking_speed
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
	
func pickup(weapon):
	can_drop=false
	$Pickup_Timer.start()
	$head/Weapon.add_child(weapon)
	

func _on_pickup_timer_timeout():
	can_drop=true

func damage():
	health -= 1
	if health <= 0:
		get_tree().change_scene_to_file("res://UI/end_game.tscn")
