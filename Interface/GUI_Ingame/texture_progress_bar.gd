extends TextureProgressBar

#func _ready() -> void:
		#player.healthChanged.connect(update)
		#player.health_player.connect(update(player.health_player))
		
#func update(health_player):
	#value = health_player * 100 / player.maxHealth
