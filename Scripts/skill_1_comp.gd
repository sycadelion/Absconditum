extends Node3D

@export var _skill1_prefab: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func skill1_throw(marker) ->void:
	var skill = _skill1_prefab.instantiate()
	var container = get_tree().get_first_node_in_group("SkillContainer")
	container.add_child(skill)
	skill.global_position = marker.global_position
