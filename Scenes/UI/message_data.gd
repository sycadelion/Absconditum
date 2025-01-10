extends HBoxContainer

@onready var killer: Label = $PanelContainer/HBoxContainer/killer
@onready var killed: Label = $PanelContainer/HBoxContainer/Killed
@onready var timer: Timer = $Timer

func set_data(kill,kille) -> void:
	killer.text = kill
	killed.text = kille

func _on_timer_timeout() -> void:
	queue_free()
