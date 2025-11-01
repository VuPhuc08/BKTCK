extends CharacterBody2D

var speed = 470
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
	elif body.name == "player2":
		zone2 = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player1":
		zone = false
	elif body.name == "player2":
		zone2 = false
func _ready() -> void:
		collision_layer = 1
		collision_mask = 2
