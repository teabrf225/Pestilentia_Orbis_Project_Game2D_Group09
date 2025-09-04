extends Node2D

@onready var fire_anime = $AnimatedSprite2D

func _ready() -> void:
	fire_anime.play()
