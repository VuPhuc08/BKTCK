extends CharacterBody2D

var speed = 350
var zone = false
var zone2 = false

func _physics_process(delta: float) -> void:
	if zone && !zone2:
		velocity.x = speed
		$AnimatedSprite2D.flip_h = false
	elif zone2 && !zone:
		velocity.x = -speed
		$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, 2)
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player1":
		zone = true
	if body.name == "player2":
		zone2 = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player1":
		zone = false
	if body.name == "player2":
		zone2 = false
