extends CharacterBody3D

@onready var head=$head
@onready var standing_collsion_shape=$standing_collsion_shape
@onready var crouching_collsion_shape=$crouching_collsion_shape
@onready var ray_cast_3d=$RayCast3D
@onready var anim_player=$AnimationPlayer
@onready var hitbox=$head/Camera3D/WeaponPivot/WeaponMesh/Hitbox

var current_speed = 5.0

const walking_speed=5.0
const sprinting_speed=12.0
const crouching_speed=3.0
const jump_velocity = 4.5

const mouse_sens=0.25

var direction= Vector3.ZERO
var lerp_speed=10.0

var crouching_depth=-.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))
		head.rotation.x=clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		anim_player.play("attack")
		hitbox.monitoring=true
		
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
	
	if Input.is_action_pressed("menu"):
		get_tree().quit()
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


func _on_animation_player_animation_finished(anim_name):
	if anim_name=="attack":
		anim_player.play("Idle")
		hitbox.monitoring=false
		
