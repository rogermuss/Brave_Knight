extends Control


func _on_start_button_button_up():
	GameManager.on_game_start()




func _on_exit_button_button_up():
	GameManager.on_exit()
