extends FmodEventEmitter3D

var OcclusionPercent: float = 33
var paraValue = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.AudioRay:
		var space_state = self.get_world_3d().direct_space_state
		var origin = self.global_position
		var listener = FmodServer.get_listener_transform3d(0)
		var end = listener.origin
		
		var query_Ray = PhysicsRayQueryParameters3D.create(origin,end)
		query_Ray.exclude = [owner,GameManager.PLAYER]
		var result = space_state.intersect_ray(query_Ray)
		var depth = float(result.size())
		if result == {}:
			self.set_parameter("Occlusion",0)
			
		else:
			paraValue = (depth * OcclusionPercent) / 100
			self.set_parameter("Occlusion",paraValue)
			await get_tree().create_timer(.01).timeout
