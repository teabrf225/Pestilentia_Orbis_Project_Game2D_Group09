extends CharacterBody2D

func _ready() -> void:
	var b = randf_range(2,5)
	await get_tree().create_timer(b).timeout
	$AnimationPlayer.play("Worm")
	$AnimatedSprite2D.play("sandworm")
