
extends CharacterBody2D

const speed = 700.0
const bien = 60
const zone_note = 2

var direction = Vector2.ZERO
var stop = 0.0
var zone1 = false
var zone2 = false

@onready var power_1 = $"../CanvasLayer/TextureProgressBar"
@onready var power_2 = $"../CanvasLayer/TextureProgressBar2"
@export var left_node: Node2D
@export var right_node: Node2D

func _ready():
	collision_layer = 1
	collision_mask = 2

func _physics_process(delta: float):
	if velocity.length() > 0.0:
		velocity = velocity.move_toward(Vector2.ZERO, 200 *delta)
	move_and_slide()
	teleport(delta)

func _on_area_2d_body_entered(body: Node2D):
	if body.name == "player1":
		hit_by_player(body, power_1)
	elif body.name == "player2":
		hit_by_player(body, power_2)

func hit_by_player(player: Node2D, power: TextureProgressBar):
	var arrow: Node2D
	if player.has_node("arrow"):
		arrow = player.get_node("arrow")
	elif player.has_node("Node2D"):
		arrow = player.get_node("Node2D")
	else:
		return
	var goc = deg_to_rad(arrow.rotation_degrees)
	direction = Vector2(cos(goc), sin(goc)).normalized()
	if player.name == "player2": 
		direction = -Vector2(cos(goc), sin(goc)).normalized() 
	var power_delta = clamp(power.value/100, 0.2 , 1.0)
	velocity = direction * speed * power_delta
	$AnimatedSprite2D.flip_h = velocity.x < 0

func teleport(delta: float):
	var screen = get_viewport().get_visible_rect()
	var note = note_position()
	if global_position.x > screen.end.x + bien:
		spawn_right()
		Global.goal_2 += 1
	elif global_position.x < screen.position.x - bien:
		spawn_left()
		Global.goal_1 += 1
	elif global_position.y > 600 && velocity >= Vector2.ZERO:
		spawn_right()
		Global.goal_2 += 1
	elif global_position.y < 45 && velocity >= Vector2.ZERO:
		spawn_right()
		Global.goal_2 += 1
	elif  global_position.y > 600 && velocity  <= Vector2.ZERO:
		spawn_left()
		Global.goal_1 += 1
	elif global_position.y < 45 && velocity <= Vector2.ZERO:
		spawn_left()
		Global.goal_1 += 1
	elif abs(velocity.x) == 0.0 && !zone1 && !zone2 && !note:
		stop += delta
		if stop > 0.0:
			if global_position.x > 67 && global_position.x < 576 && global_position.y > 90 && global_position.y < 557.75:
				spawn_right()
				Global.goal_2 += 1
			if global_position.x < 1086 && global_position.x > 576 && global_position.y > 90 && global_position.y < 557.75:
				spawn_left()
				Global.goal_1 += 1
			if global_position.x > 1086:
				spawn_right()
				Global.goal_2 += 1
			if global_position.x < 67:
				spawn_left()
				Global.goal_1 += 1

func note_position() -> bool:
	if left_node && right_node:
		var to_left = abs(global_position.x - left_node.global_position.x)
		var to_right = abs(global_position.x - right_node.global_position.x)
		return to_left <= zone_note || to_right <= zone_note
	return false

func spawn_left():
	var screen = get_viewport().get_visible_rect()
	if left_node:
		global_position = left_node.global_position
	else:
		global_position = Vector2(screen.position.x - 100, global_position.y)
	velocity = Vector2.ZERO

func spawn_right():
	var screen = get_viewport().get_visible_rect()
	if right_node:
		global_position = right_node.global_position
	else:
		global_position = Vector2(screen.end.x + 100, global_position.y)
	velocity = Vector2.ZERO
