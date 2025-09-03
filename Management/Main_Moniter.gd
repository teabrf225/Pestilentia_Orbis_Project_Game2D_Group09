extends Node

var death_count: int = 0
@export var max_deaths: int = 3

func _ready():
	reset_game()

func reset_game():
	death_count = 0

func player_died():
	death_count += 1
	print("Player died! Death count: ", death_count)
	if death_count >= max_deaths:
		game_over()

func game_over():
	print("GAME OVER")
	# โหลดฉาก Game Over หรือ Popup
	get_tree().change_scene_to_file("res://Interface/gameOver/game_over.tscn")
