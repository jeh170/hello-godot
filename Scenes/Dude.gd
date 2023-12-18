extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -550.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var momentum = 0;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		handle_air_drift(delta)
		$Sprite.stop()
	else:
		momentum = Input.get_axis("player_left", "player_right")
		# Get the input momentum and handle the movement/deceleration.
		if momentum:
			velocity.x = momentum * SPEED
			$Sprite.flip_h = momentum < 0
			$Sprite.play("running_left")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$Sprite.stop()

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	move_and_slide()
	
func handle_air_drift(delta):

	var direction = Input.get_axis("player_left", "player_right")
	
	if Input.is_action_pressed("player_jump"):
		momentum = Input.get_axis("player_left", "player_right")
		
	if Input.is_action_pressed("player_down"):
		velocity.y += gravity * delta * 3
	else: 
		velocity.y += gravity * delta
	
	if direction && momentum && direction != momentum:
		velocity.x = momentum * SPEED / 2
	elif momentum:
		velocity.x = momentum * SPEED
		
