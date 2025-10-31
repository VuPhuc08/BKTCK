extends CharacterBody2D

@export var speed = 50
var zone = false

func _physics_process(delta: float) -> void:
	if zone:
		velocity.x = speed  
		velocity.y = speed  
	else:
		velocity.x = 0
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player1" or body.name == "player2":
		zone = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player1" or body.name == "player2":
		zone = false
