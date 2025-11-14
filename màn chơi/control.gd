extends Node

@onready var Pause_menu = $"../CanvasLayer/Pause_Menu"
var Pause : bool = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Pause = !Pause
	if Pause == true:
		get_tree().paused = true
		Pause_menu.show()
	else:
		get_tree().paused = false
		Pause_menu.hide()

func _on_resume_pressed() -> void:
	Pause = !Pause

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Godminton/mở màn/màn_hình_chờ.tscn")
