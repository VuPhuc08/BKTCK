extends CharacterBody2D

const SPEED = 300.0
var delta_arrow = 180.0

@onready var arrow = $Node2D
@onready var power = $"../CanvasLayer/TextureProgressBar2"

func _ready() -> void:
	power.max_value = 100
	power.min_value = 0

func _process(_float):
	var power_plus := Input.is_action_just_pressed("power_++")
	var power_minus := Input.is_action_just_pressed("power_--")
	if power_plus:
		power.value += 20
	if power_minus:
		power.value -= 20 

func _physics_process(_float):
	var movey := Input.get_axis("ui_up", "down")
	if movey:
		velocity.y = movey * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	var movex := Input.get_axis("ui_left", "ui_right")
	if movex:
		velocity.x = movex * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if Input.is_action_just_pressed("up2"):
		delta_arrow += 30
	if Input.is_action_just_pressed("down2"):
		delta_arrow -= 30
	delta_arrow = clamp(delta_arrow, 180.0, 360.0)
	arrow.rotation_degrees = delta_arrow
