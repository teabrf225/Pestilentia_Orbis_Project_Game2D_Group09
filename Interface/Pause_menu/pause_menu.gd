extends Control

func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()
	
func _input(event):
	if event.is_action_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	resume()

func _on_option_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
