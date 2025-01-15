extends Control

@onready var pBar: ProgressBar = $PanelContainer/MarginContainer/ProgressBar
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = GameManager.skill_Cooldown + 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pBar.value = (timer.time_left * 100)

func used_skill():
	if pBar.value <= 0:
		timer.start()
		
		return true
	else:
		return false
		
func _on_timer_timeout() -> void:
	timer.stop()
