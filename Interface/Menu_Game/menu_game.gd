extends Control

@onready var Main_buttons: VBoxContainer = $Main_buttons
@onready var Options: Panel = $Options
@onready var Credits: Panel = $Credits

func _ready() -> void:
	Main_buttons.visible = true
	Options.visible = false
	Credits.visible = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://World/Test/world_test.tscn")


func _on_option_pressed() -> void:
	Options.visible = true



func _on_credit_pressed() -> void:
	Credits.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_options_pressed() -> void:
	_ready()
