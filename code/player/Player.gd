extends KinematicBody2D

export (int) var ACCELERATION: int = 512
export (int) var MAX_SPEED: int = 64
export (int) var FRICTION: float = 0.25
export (int) var GRAVITY: int = 200
export (int) var JUMP_FORCE: int = 128
export (int) var MAX_SLOPE_ANGLE: int = 46

var motion: Vector2 = Vector2.ZERO

func __get_player_input_vector() -> Vector2:
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector
	
func __apply_horizontal_motion(input_vector: Vector2, delta: float):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func __apply_friction(input_vector: Vector2):
	if input_vector.x == 0 and is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION)

func __apply_gravity(delta: float):
	motion.y += GRAVITY * delta

func __jump_motion(input_vector: Vector2):
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		motion.y = -JUMP_FORCE
	elif(Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2):
		motion.y = -JUMP_FORCE/2
		
	if input_vector.x == 0 and not is_on_floor():
		motion.x = 0

func _physics_process(delta: float):
	var input_vector: Vector2 = __get_player_input_vector()
	
	__apply_horizontal_motion(input_vector, delta)
	__apply_friction(input_vector)
	__jump_motion(input_vector)
	__apply_gravity(delta)
		
	motion = move_and_slide(motion, Vector2.UP)
