class_name Player
extends CharacterBody3D


@export var SPEED: float = 5.0
@export var sensitivity: float = 0.5
const JUMP_VELOCITY = 4.5

@onready var Pivot: Node3D = $CollisionShape3D/Pivot
@onready var Cast: RayCast3D = $CollisionShape3D/Pivot/Camera3D/RayCast3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	if (Engine.get_physics_frames() % 5 == 0 and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		if(Cast.is_colliding()):
			print(Cast.get_collider())
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		Pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		Pivot.rotation.x = clampf(Pivot.rotation.x, deg_to_rad(-70), deg_to_rad(70))
