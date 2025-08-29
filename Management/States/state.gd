extends Node
class_name State

@onready var debug = owner.find_child("debug_action")
@onready var player: Player = owner.find_child("Player")
@export var enemy: Enemy
@export var animation_player: AnimationPlayer
@export var animation_sprite: AnimatedSprite2D

@export var name_animation: String = ""
@export var action_next_state: Array[State] = [] # ลาก node ของ state ต่อไปได้จาก Inspector

signal request_state_change(new_state: State)

func enter():
	set_physics_process(true)
	_play_animation()

func exit():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	update_state(delta)
	transition()
	if debug:
		debug.text = name_animation

func update_state(_delta: float) -> void:
	pass

func transition() -> void:
	pass

func request_change_to(new_state: State) -> void:
	emit_signal("request_state_change", new_state)

func _play_animation():
	if name_animation == "":
		return
	if animation_player and animation_player.has_animation(name_animation):
		animation_player.play(name_animation)
	elif animation_sprite and animation_sprite.sprite_frames.has_animation(name_animation):
		animation_sprite.play(name_animation)
