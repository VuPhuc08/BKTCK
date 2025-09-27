extends CharacterBody2D
var speed = 150
var gravity = 700

var vel = Vector2()

func _physics_process(delta):
	if Input.is_action_just_pressed("player left"):
		vel.x -= speed
	elif Input.is_action_just_pressed("player right"):
		vel.x += speed

    move_and_slide(vel, Vector.UP)
