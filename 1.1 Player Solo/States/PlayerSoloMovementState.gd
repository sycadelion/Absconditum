class_name PlayerSoloMovementState extends State

var PLAYER: PlayerSolo
var ANIMATION: AnimationPlayer
var HEALTH: HealthCompSolo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	PLAYER = owner as PlayerSolo
	ANIMATION = PLAYER.anim_player
	HEALTH = PLAYER.health_comp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
