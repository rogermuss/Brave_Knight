extends Control


func _on_retry_button_button_up() -> void:
		GameManager.on_return_to_menu()
	
func _on_menu_button_button_up() -> void:
	GameManager.on_game_start()
	
