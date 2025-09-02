extends Area2D

# Define the next scene to load in the inspector
@export var next_scene : String

# Load next level scene when player collide with level finish door.
func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("player", "death_tween") # death_tween is called here just to give the feeling of player entering the door.
		# AudioManager.level_complete_sfx.play()
		SceneTransitions.load_scene(next_scene)
		print("already in")
