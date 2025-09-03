extends Area2D
class_name Potal

@export var next_scene: PackedScene
var locked: bool = true   # เริ่มต้นปิดไว้

# เรียกตอน Boss ตาย
func unlock():
	locked = false
	print("Door unlocked!")

func _on_body_entered(body):
	if body.is_in_group("player"):
		if locked:
			print("The door is locked. Defeat the Boss first!")
			return

		# เอฟเฟกต์เหมือนเข้าไปในประตู
		get_tree().call_group("player", "death_tween")
		# AudioManager.level_complete_sfx.play()
		SceneTransitions.load_scene(next_scene)
		print("already in")


func _on_king_slime_boss_defeated() -> void:
	unlock() # Replace with function body.


func _on_dullahan_boss_defeated() -> void:
	unlock() # Replace with function body.
