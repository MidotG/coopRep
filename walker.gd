extends CharacterBody3D

@export var mouse_sensitivity: float = 0.006;
@onready var spring_arm: SpringArm3D = $SpringArm3D;
@onready var animation_player = $AnimationPlayer;
@onready var attack_interv = $Weapon/attackInterv;


const SPEED = 5.0
const JUMP_VELOCITY = 5

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
	#print(attack_interv.time_left);
	if true:
		animation_player.play("1H_Melee_Attack_Chop");
		pass;
	if attack_interv.time_left > 0:
		pass;
	if not is_on_floor():
		velocity.y -= gravity * delta
		#animation_player.play("Jump_Start");

	#///TODO: сделать отключение других анимаций и их появление во время этой. 
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#animation_player.play("Jump_Start");
		velocity.y = JUMP_VELOCITY
		#animation_player.queue("Jump_Land")
	if Input.is_action_just_pressed("esc"):
		get_tree().quit();
	#///TODO: тоже самое. В общем сделать очередь, пока не закончится анимация, то нельзя другим начинать.
	if Input.is_action_just_pressed("attack"):
		#if attack_interv.time_left == 0:
		attack_interv.start();
		animation_player.play("1H_Melee_Attack_Slice_Diagonal");
		pass;
		
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor():
			animation_player.play("Running_B");
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_on_floor():
			animation_player.play("Idle");
	move_and_slide()


func _on_attack_interv_timeout():
	animation_player.stop();
