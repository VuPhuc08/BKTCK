extends CharacterBody2D

const SPEED = 300.0
@export var left_position_left: Node2D
@export var left_position_right: Node2D

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
