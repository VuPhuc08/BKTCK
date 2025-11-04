extends CharacterBody2D

@onready var speed = 350
var zone = false
var zone2 = false
var initial_position: Vector2
var stop_timer: float = 0.0
var stop_time_threshold: float = 0.1

func _ready() -> void:
	initial_position = global_position
	collision_layer = 1
	collision_mask = 2

func _physics_process(delta: float) -> void:
	# Xử lý di chuyển
	if zone && !zone2:
		velocity.x = speed
		$AnimatedSprite2D.flip_h = false
		stop_timer = 0.0
	elif zone2 && !zone:
		velocity.x = -speed
		$AnimatedSprite2D.flip_h = true
		stop_timer = 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, 2)
		if abs(velocity.x) < 1.0:
			stop_timer += delta
			if stop_timer >= stop_time_threshold:
				reset_to_initial_position()
		else:
			stop_timer = 0.0
	
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

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	reset_to_initial_position()

func reset_to_initial_position():
	global_position = initial_position
	velocity = Vector2.ZERO
	zone = false
	zone2 = false
	stop_timer = 0.0
