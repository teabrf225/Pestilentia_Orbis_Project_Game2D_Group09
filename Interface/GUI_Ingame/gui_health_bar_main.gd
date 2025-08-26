extends CanvasLayer

@export var player: CharacterBody2D

var Gui_ingame_object = Gui_ingame

class Gui_ingame:
	func _init(player) -> void:
		var player_hp = player
