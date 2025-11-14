extends Node

@onready var Pause_menu = $"../CanvasLayer/Pause_Menu"
var Pause : bool = false
var save_path = "user://savegame.save"
@onready var player_1 = $"../player1"
@onready var player_2 = $"../player2"
@onready var quả_cầu = $"../quả cầu"

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

func save_game():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(Global.goal_1)
	file.store_var(Global.goal_2)
	file.store_var(player_1.position.x)
	file.store_var(player_1.position.y)
	file.store_var(player_2.position.x)
	file.store_var(player_2.position.y)
	file.store_var(quả_cầu.position.x)
	file.store_var(quả_cầu.position.y)

func load_game():
	var file = FileAccess.open(save_path,FileAccess.READ)
	Global.goal_1 = file.get_var(Global.goal_1)
	Global.goal_2 = file.get_var(Global.goal_2)
	player_1.position.x = file.get_var(player_1.position.x)
	player_1.position.y = file.get_var(player_1.position.y)
	player_2.position.x = file.get_var(player_2.position.x)
	player_2.position.y = file.get_var(player_2.position.y)
	quả_cầu.position.x = file.get_var(quả_cầu.position.x)
	quả_cầu.position.y = file.get_var(quả_cầu.position.y)

func _on_save_pressed() -> void:
	save_game()
	Pause = !Pause

func _on_load_pressed() -> void:
	load_game()
	Pause = !Pause
