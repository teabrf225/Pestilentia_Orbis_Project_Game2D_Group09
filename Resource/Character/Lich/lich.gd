extends Enemy

signal boss_defeated

@export var is_final_boss: bool = false   # <--- เพิ่มบรรทัดนี้

func _on_died():
	super._on_died()
	emit_signal("boss_defeated")

	if is_final_boss:   # ถ้าเป็นบอสตัวสุดท้าย
		show_end_credits()

func show_end_credits():
	get_tree().change_scene_to_file("res://Interface/End_Credits/end_credits.tscn")
