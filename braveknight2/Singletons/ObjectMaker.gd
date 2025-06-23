extends Node

@export var bomb_ref = preload("res://Scenes/Bomb/bomb.tscn")

var velocity = Vector2.ZERO

func create_bomb(initial_pos: Vector2, target_pos: Vector2):
	var bomb = bomb_ref.instantiate()
	bomb.global_position = initial_pos
	
	bomb.setup(target_pos)
	
	get_tree().get_current_scene().add_child(bomb)
