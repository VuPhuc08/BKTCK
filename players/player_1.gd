extends CharacterBody2D

const SPEED = 300.0

@onready var arrow = $arrow
@onready var power = $"../CanvasLayer/TextureProgressBar"

func _ready() -> void:
	power.max_value = 100
	power.min_value = 0

func process(delta: float) -> void:
	var delta_power_minus := Input.is_action_just_pressed("power_+")
	var delta_power_plus := Input.is_action_just_pressed("power_-")
	if delta_power_minus:
		power.value -= 20
	if delta_power_plus:
		power.value += 20 

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
