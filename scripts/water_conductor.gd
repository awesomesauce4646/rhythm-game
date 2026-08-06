extends AudioStreamPlayer

@export var bpm = 147.66
@export var manual_offset := 0.0   # in seconds, tune this per platform

var beat := 0.0
var started := false
var song_start_ticks := 0.0

func _ready() -> void:
	set_process(false)

func start_song() -> void:
	if started:
		return
	started = true
	play()
	song_start_ticks = Time.get_ticks_usec() / 1000000.0
	set_process(true)

func _process(delta: float) -> void:
	var now = Time.get_ticks_usec() / 1000000.0
	var song_pos = now - song_start_ticks + manual_offset
	beat = song_pos * bpm / 60.0
