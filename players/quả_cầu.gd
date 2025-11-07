extends CharacterBody2D

const speed = 700
const bien = 30
const note_zone = 2 

var stop = 0.0
var zone1 = false
var zone2 = false

@onready var power_1 = $"../CanvasLayer/TextureProgressBar"
@onready var power_2 = $"../CanvasLayer/TextureProgressBar2"
@export var left_node: Node2D
@export var right_node: Node2D

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player1":
		zone1 = true
	elif body.name == "player2":
		zone2 = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player1":
		zone1 = false
	elif body.name == "player2":
		zone2 = false

func _physics_process(delta: float) -> void:
	if zone1 && !zone2:
			if power_1.value == 20:
				velocity.x = speed / 5.0
				$AnimatedSprite2D.flip_h = false
			elif power_1.value == 40:
				velocity.x = speed * 2.0 / 5.0
				$AnimatedSprite2D.flip_h = false
			elif  power_1.value == 60:
				velocity.x = speed * 3.0 / 5.0
				$AnimatedSprite2D.flip_h = false
			elif power_1.value == 80:
				velocity.x = speed * 4.0 / 5.0
				$AnimatedSprite2D.flip_h = false
			elif power_1.value == 100:
				velocity.x = speed
				$AnimatedSprite2D.flip_h = false
			else:
				velocity.x = 0
				$AnimatedSprite2D.flip_h = false
	elif zone2 && !zone1:
			if power_1.value == 20:
				velocity.x = -speed / 5.0
				$AnimatedSprite2D.flip_h = true
			elif power_1.value == 40:
				velocity.x = -speed * 2.0 / 5.0
				$AnimatedSprite2D.flip_h = true
			elif  power_1.value == 60:
				velocity.x = -speed * 3.0 / 5.0
				$AnimatedSprite2D.flip_h = true
			elif power_1.value == 80:
				velocity.x = -speed * 4.0 / 5.0
				$AnimatedSprite2D.flip_h = true
			elif power_1.value == 100:
				velocity.x = -speed
				$AnimatedSprite2D.flip_h = true
			else:
				velocity.x = 0
				$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, 2)
	move_and_slide()
	teleport(delta)

func teleport(delta: float): 
	var screen = get_viewport().get_visible_rect()
	var note = note_position()
	if global_position.x > screen.end.x + bien:
		spawn_right()
	elif global_position.x < screen.position.x - bien:
		spawn_left()
	elif abs(velocity.x) == 0.0 && !zone1 && !zone2 && !note:
		stop += delta
		if stop > 0.0:
			if global_position.x > 1085.75 || global_position.y < 90 || global_position.x < 576:
				spawn_right()
			else:
				spawn_left()

func note_position() -> bool:
	if left_node && right_node:
		var to_left = abs(global_position.x - left_node.global_position.x)
		var to_right = abs(global_position.x - right_node.global_position.x)
		return to_left <= note_zone || to_right <= note_zone
	return false

func spawn_left():
	var screen = get_viewport().get_visible_rect()
	if left_node:
		global_position = left_node.global_position
	else:
		global_position = Vector2(screen.position.x - 100, global_position.y)
	reset()

func spawn_right():
	var screen = get_viewport().get_visible_rect()
	if right_node:
		global_position = right_node.global_position
	else:
		global_position = Vector2(screen.end.x + 100, global_position.y)
	reset()

func reset():
	velocity = Vector2.ZERO
