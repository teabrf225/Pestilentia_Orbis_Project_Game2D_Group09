extends State

@export var enemy: Enemy


func enter():
	super.enter()
	if animation_sprite:
		animation_sprite.animation_finished.connect(on_dead)
	if animation_player:
		animation_player.animation_finished.connect(on_dead)
	
func exit():
	super.exit()

func on_dead():
	print("Dead NoW!!! Bro")
	enemy.queue_free()
