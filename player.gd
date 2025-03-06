extends VehicleBody3D

# Сила двигателя (используем встроенное свойство)
var acceleration_force: float = 500.0
# Сила торможения (используем встроенное свойство)
var braking_force: float = 10.0
# Максимальный угол поворота колес (в градусах)
@export var max_steering_angle: float = 30.0

# Ссылки на колеса (назначь их в редакторе)
@export var front_left_wheel: VehicleWheel3D
@export var front_right_wheel: VehicleWheel3D

func _physics_process(delta: float) -> void:
	# Отладочный вывод для проверки действий
	if Input.is_action_pressed("accelerate"):
		print("Accelerate pressed")  # Движение вперед
	if Input.is_action_pressed("brake"):
		print("Brake pressed")       # Торможение или движение назад
	if Input.is_action_pressed("steer_left"):
		print("Steer left pressed")  # Поворот влево
	if Input.is_action_pressed("steer_right"):
		print("Steer right pressed") # Поворот вправо

	# Управление движением вперед/назад
	if Input.is_action_pressed("accelerate"):
		# Ускоряемся вперед
		engine_force = acceleration_force
	elif Input.is_action_pressed("brake"):
		# Тормозим или движемся назад
		engine_force = -acceleration_force * 0.5  # Меньшая сила для движения назад
	else:
		# Если не нажаты клавиши, двигатель не работает
		engine_force = 0.0

	# Управление торможением
	if Input.is_action_pressed("brake"):
		brake = braking_force
	else:
		brake = 0.0

	# Управление поворотом
	var steering: float = 0.0
	if Input.is_action_pressed("steer_left"):
		steering = max_steering_angle
	elif Input.is_action_pressed("steer_right"):
		steering = -max_steering_angle

	# Применяем поворот к передним колесам (если они назначены)
	if front_left_wheel:
		front_left_wheel.steering = deg_to_rad(steering)
	if front_right_wheel:
		front_right_wheel.steering = deg_to_rad(steering)
