extends CharacterBody2D

const BASE_SPEED := 700.0
const BIEN := 30
const NOTE_ZONE := 2

var direction := Vector2.ZERO
var stop := 0.0
var delay := 0.0
var zone1 := false
var zone2 := false

@onready var power_1 := $"../CanvasLayer/TextureProgressBar"
@onready var power_2 := $"../CanvasLayer/TextureProgressBar2"
@export var left_node: Node2D
@export var right_node: Node2D

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2

func _physics_process(delta: float) -> void:
	move_and_slide()
	teleport(delta)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player1":
		_hit_by_player(body, power_1)
	elif body.name == "player2":
		_hit_by_player(body, power_2)

func _hit_by_player(player: Node2D, power_bar: TextureProgressBar) -> void:
	var arrow_node: Node2D
	if player.has_node("arrow"):
		arrow_node = player.get_node("arrow")
	elif player.has_node("Node2D"):
		arrow_node = player.get_node("Node2D")
	else:
		return
	var angle = deg_to_rad(arrow_node.rotation_degrees)
	direction = Vector2(cos(angle), sin(angle)).normalized()
	var power_ratio = clamp(power_bar.value / 100.0, 0.2, 1.0)
	velocity = direction * BASE_SPEED * power_ratio
	$AnimatedSprite2D.flip_h = velocity.x < 0

func teleport(delta: float):
	var screen = get_viewport().get_visible_rect()
	var note = note_position()

	if global_position.x > screen.end.x + BIEN:
		spawn_right()
	elif global_position.x < screen.position.x - BIEN:
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
		return to_left <= NOTE_ZONE || to_right <= NOTE_ZONE
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
