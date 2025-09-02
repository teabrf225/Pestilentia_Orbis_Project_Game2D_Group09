extends CanvasLayer

signal on_animation_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer


func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "Fade_Normal_to_Black":
		on_animation_finished.emit()
		#print('Scene Transition Fade_Black_to_Normal') if Global.debug_mode else null
		animation_player.play("Fade_Black_to_Normal")
	elif anim_name == "Fade_Black_to_Normal":
		#print('Scene Transition Fade_Black_to_Normal end') if Global.debug_mode else null
		color_rect.visible = false

func transition():
	color_rect.visible = true
	animation_player.play("Fade_Normal_to_Black")

func load_scene(next_scene):
	SceneTransitions.transition()
	await SceneTransitions.on_animation_finished
	var loading_scene = load(next_scene)
	get_tree().change_scene_to_packed(loading_scene)
