extends Enemy

signal boss_defeated

func _on_died():
	super._on_died()  # เรียกของ Enemy ก่อน (เปลี่ยน state → dead)
	emit_signal("boss_defeated")  # ส่งสัญญาณบอกว่าบอสตายแล้ว
