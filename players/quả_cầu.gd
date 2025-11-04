extends CharacterBody2D

@onready var speed = 500
var zone = false
var zone2 = false
@export var left_position: Node2D
@export var right_position: Node2D
var stop_timer: float = 0.0
var note_margin: float = 50.0

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2

func _physics_process(delta: float) -> void:
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
	
	move_and_slide()
	check_teleport_conditions(delta)

func check_teleport_conditions(delta: float):
	var viewport_rect = get_viewport().get_visible_rect()
	var margin = 30
	
	# Kiểm tra xem có đang ở vị trí note không
	var at_note_position = is_at_note_position()
	
	# ĐK 1: Ra khỏi màn hình -> teleport ngay (trừ khi đang ở vị trí note)
	if global_position.x > viewport_rect.end.x + margin && !at_note_position:
		spawn_at_left()
	elif global_position.x < viewport_rect.position.x - margin && !at_note_position:
		spawn_at_right()
	
	# Điều kiện 2: Đã dừng hoàn toàn, không có player, và KHÔNG ở vị trí note
	elif abs(velocity.x) < 1.0 && !zone && !zone2 && !at_note_position:
		stop_timer += delta
		if stop_timer >= 3.0:
			var screen_center_x = viewport_rect.position.x + (viewport_rect.size.x / 2)
			if global_position.x > screen_center_x:
				spawn_at_left()
			else:
				spawn_at_right()
	else:
		stop_timer = 0.0

# Kiểm tra theo trục X (chỉ quan tâm vị trí ngang)
func is_at_note_position() -> bool:
	if left_position && right_position:
		# Chỉ kiểm tra khoảng cách theo trục X
		var x_distance_to_left = abs(global_position.x - left_position.global_position.x)
		var x_distance_to_right = abs(global_position.x - right_position.global_position.x)
		
		return x_distance_to_left <= note_margin || x_distance_to_right <= note_margin
	
	return false

func spawn_at_left():
	if left_position:
		global_position = left_position.global_position
	else:
		var viewport_rect = get_viewport().get_visible_rect()
		global_position = Vector2(viewport_rect.position.x - 100, global_position.y)
	reset_state()

func spawn_at_right():
	if right_position:
		global_position = right_position.global_position
	else:
		var viewport_rect = get_viewport().get_visible_rect()
		global_position = Vector2(viewport_rect.end.x + 100, global_position.y)
	reset_state()

func reset_state():
	velocity = Vector2.ZERO
	zone = false
	zone2 = false
	stop_timer = 0.0

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
