extends Label

@export var base_text: String = "Loading"
@export var speed: float = 0.5 

var dot_count := 0
var timer: Timer

func _ready():
	text = base_text
	timer = Timer.new()
	timer.wait_time = speed
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timeout)

func _on_timeout():
	dot_count = (dot_count + 1) % 4  # นับ 0..3
	text = base_text + ".".repeat(dot_count)
