extends CharacterBody3D

@export var mouse_sensitivity: float = 0.006;
@onready var spring_arm: SpringArm3D = $SpringArm3D;
@onready var animation_player = $AnimationPlayer


const SPEED = 5.0
const JUMP_VELOCITY = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# Вращение камеры по вертикали (вверх/вниз)
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

		# Вращение игрока по горизонтали (влево/вправо)
		rotation.y -= event.relative.x * mouse_sensitivity

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#///TODO: сделать отключение других анимаций и их появление во время этой. 
		#animation_player.play("Jump_Start");
		#animation_player.queue("Jump_Land")
	if Input.is_action_just_pressed("esc"):
		get_tree().quit();
	if Input.is_action_just_pressed("attack"):
		#///TODO: тоже самое. В общем сделать очередь, пока не закончится анимация, то нельзя другим начинать.
		#animation_player.play("1H_Melee_Attack_Slice_Diagonal");
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		animation_player.play("Running_B");
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		animation_player.play("Idle");

	move_and_slide()
