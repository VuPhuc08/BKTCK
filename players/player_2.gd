extends CharacterBody2D

const SPEED = 300.0
@export var right_position_left: Node2D
@export var right_position_right: Node2D

func _physics_process(delta: float) -> void:
	var movey := Input.get_axis("ui_up", "ui_down")
	if movey:
		velocity.y = movey * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	var movex := Input.get_axis("ui_left", "ui_right")
	if movex:
		velocity.x = movex * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	var movearrowD := Input.get_action_strength("down1")
	var movearrowU := Input.get_action_strength("up1")
	arrow.rotation_degrees += (movearrowD - movearrowU) * 100 * delta
	arrow.rotation_degrees = clamp(arrow.rotation_degrees, 0, 180)
