extends CharacterBody2D

func _ready() -> void:
	var b = randf_range(2,5)
	await get_tree().create_timer(b).timeout
	$AnimationPlayer.play("lightning")
	$AnimatedSprite2D.play("Lightning")
