extends AudioStreamPlayer

@export var bpm = 150

var beat := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	beat = get_playback_position() * bpm / 60
	pass
