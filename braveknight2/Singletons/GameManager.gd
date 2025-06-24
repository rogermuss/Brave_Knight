extends Node
var hp = 3
var game_over = false
var game_escene = preload("res://Scenes/BaseLevel/BaseLevel.tscn")
var menu_scene = preload("res://scenes/main_menu/Menu.tscn")
#var sublevel_scene = preload("res://scenes/sub_level/sub_level.tscn")

func _ready():
	game_over = false
	
func on_game_start():
	get_tree().change_scene_to_packed(game_escene)
	
func on_return_to_menu():
	get_tree().change_scene_to_packed(menu_scene)

func lower_hp():
	hp -= 1
	SignalManager.on_health_update.emit(hp)

func reset_hp():
	hp = 3
	SignalManager.on_health_update.emit(hp)

func on_exit():
	get_tree().quit()
	
#func on_entering_sublevel():
	#get_tree().change_scene_to_packed(sublevel_scene)
	
