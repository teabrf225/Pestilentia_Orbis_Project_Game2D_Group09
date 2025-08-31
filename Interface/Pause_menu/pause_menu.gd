extends Control
@onready var Options: Panel = $Options
@onready var Pause: Panel = $Panel

func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()
	Options.visible = false
	
func _input(event):
	if event.is_action_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	resume()

func _on_option_pressed() -> void:
	Options.visible = true
	

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	Options.visible = false


func _on_pause_button_pressed() -> void:
	pause()
