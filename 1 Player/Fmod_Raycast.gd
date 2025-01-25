extends FmodEventEmitter3D

var OcclusionPercent: float = 33

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.AudioRay and Engine.get_process_frames() % 5 == 0:
		const MAX_COLLISIONS: int = 3
		var entities: Array = []
		var exclude = [owner,GameManager.PLAYER]
		var paraValue = 0
		var space_state = self.get_world_3d().direct_space_state
		var origin = self.global_position
		var listener = FmodServer.get_listener_transform3d(0)
		var end = listener.origin

		for i in MAX_COLLISIONS:
			var query = PhysicsRayQueryParameters3D.create(origin,end)
			query.set_exclude(exclude)
			var result = space_state.intersect_ray(query)
			if result:
				entities.append(result.collider)
				exclude.append(result.rid)
				origin = result.position
			else:
				break

		paraValue = (entities.size() * OcclusionPercent) / 100
		self.set_parameter("Occlusion",paraValue)
