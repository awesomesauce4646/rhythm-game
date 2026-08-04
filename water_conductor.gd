extends AudioStreamPlayer

@export var bpm = 147.66
var beat := 0.0
var started := false

func _ready() -> void:
	set_process(false) # don't tick beat until we actually start

func start_song() -> void:
	if started:
		return
	started = true
	play()
	set_process(true)

func _process(delta: float) -> void:
	var song_pos = get_playback_position() + AudioServer.get_time_since_last_mix()
	song_pos -= AudioServer.get_output_latency()
	beat = song_pos * bpm / 60
