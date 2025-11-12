extends CharacterBody2D

const SPEED = 300.0
var delta_arrow = 0.0

@onready var arrow = $arrow
@onready var power1 = $"../CanvasLayer/TextureProgressBar"

func _ready():
	power1.max_value = 100
	power1.min_value = 0

func _process(_delta: float):
	var power_plus := Input.is_action_just_pressed("power_+")
	var power_minus := Input.is_action_just_pressed("power_-")
	if power_plus:
		power1.value += 20
	if power_minus:
		power1.value -= 20

func _physics_process(_delta: float):
	var movey := Input.get_axis("player down", "player up")
	if movey:
		velocity.y = movey * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	var movex := Input.get_axis("player left", "player right")
	if movex:
		velocity.x = movex * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if Input.is_action_just_pressed("down1"):
		delta_arrow += 30
	if Input.is_action_just_pressed("up1"):
		delta_arrow -= 30
	delta_arrow = clamp(delta_arrow, -90.0, 90.0)
	arrow.rotation_degrees = delta_arrow
