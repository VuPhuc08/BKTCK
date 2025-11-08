extends CharacterBody2D

const SPEED = 300.0

@onready var arrow = $arrow
@onready var power1 = $"../CanvasLayer/TextureProgressBar"

func _process(delta: float) -> void:
	var power_plus := Input.is_action_just_pressed("power_+")
	var power_minus := Input.is_action_just_pressed("power_-")
	if power_plus:
		power1.value += 20
	if power_minus:
		power1.value -= 20

func _ready() -> void:
	power1.max_value = 100
	power1.min_value = 0

func _physics_process(delta: float) -> void:
	var movey := Input.get_axis("player down", "player up")
	if movey:
		velocity.y = movey * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	var movex := Input.get_axis("player left", "player right")
	if movex:
		velocity.x = movex * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	var movearrowD := Input.get_action_strength("down1")
	var movearrowU := Input.get_action_strength("up1")
	arrow.rotation_degrees += (movearrowD - movearrowU) * 100 * delta
	arrow.rotation_degrees = clamp(arrow.rotation_degrees, 0, 180)
