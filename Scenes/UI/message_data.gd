extends HBoxContainer

@onready var killer: Label = $PanelContainer/HBoxContainer/killer
@onready var killed: Label = $PanelContainer/HBoxContainer/Killed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_data(kill,kille) -> void:
	killer.text = kill
	killed.text = kille
