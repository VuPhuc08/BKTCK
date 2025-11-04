extends CharacterBody2D

const speed = 500
var zone = false
var zone2 = false
@export var left_position: Node2D
@export var right_position: Node2D
var stop = 0.0
var note = 50.0 

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2

func _physics_process(delta: float) -> void:
	if zone && !zone2:
		velocity.x = speed
		$AnimatedSprite2D.flip_h = false
	if zone2 && !zone:
		velocity.x = -speed
		$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, 2)
	
	move_and_slide()
	teleport_conditions(delta)
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

func teleport_conditions(delta: float): 
	var screen = get_viewport().get_visible_rect()
	var bien = 30
	var at_note_position = is_note_position()
	# ĐK 1: Ra khỏi màn hình = tele
	if global_position.x > screen.end.x + bien:
		spawn_right()
	elif global_position.x < screen.position.x - bien:
		spawn_left()
	
	# ĐK 2: Đã dừng, không có player, và không ở note
	elif abs(velocity.x) == 0.0 && !zone && !zone2 && !at_note_position:
		stop += delta
		# Dừng tele
		if stop > 0.0:
			if global_position.x > 1085.75 || global_position.y < 90 || global_position.y > 558 && global_position.y > (screen.size.x / 2):
				spawn_right()
			else:
				spawn_left()

func is_note_position() -> bool:
	if left_position && right_position:
		var to_left = abs(global_position.x - left_position.global_position.x)
		var to_right = abs(global_position.x - right_position.global_position.x)
		
		return to_left <= note || to_right <= note
	
	return false

func spawn_left():
	var screen = get_viewport().get_visible_rect()
	if left_position:
		global_position = left_position.global_position
	else:
		global_position = Vector2(screen.position.x - 100, global_position.y)
	reset_state()

func spawn_right():
	var screen = get_viewport().get_visible_rect()
	if right_position:
		global_position = right_position.global_position
	else:
		global_position = Vector2(screen.end.x + 100, global_position.y)
	reset_state()

func reset_state():
	velocity = Vector2.ZERO
	zone = false
	zone2 = false
