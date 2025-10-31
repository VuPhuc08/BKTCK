extends CharacterBody2D

var speed = 200
var zone = false
var zone2 = false

func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.y = 0
	if zone && !zone2:
		velocity.x = speed
		velocity.y = -speed
	elif zone2 && !zone:
		velocity.x = -speed
		velocity.y = -speed
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
