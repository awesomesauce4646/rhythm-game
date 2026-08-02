extends AudioStreamPlayer

@export var bpm = 147.66

var beat := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pitch_scale = .5
	beat = get_playback_position() * bpm / 60
	pass
	
func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	play()
