extends Node2D

@onready var judgement_text: RichTextLabel = $Judgement
@onready var click_text: RichTextLabel = $ClickToPlay
@onready var score_text: RichTextLabel = $EndScore
@onready var end_screen: TextureRect = $EndBackground
@onready var song_icon: TextureRect = $Upbeat_Icon

const SCORE_FONT = preload("res://PeaceMarker-XGzrK.otf")

var notes = [
	[0.59, 2.99, 11.01, 17.04, 19.11, 30.28, 32.13, 40.97, 44.29, 50.94, 51.83, 55.95, 59.25, 63.3, 67.02, 69.26, 76.11, 78.38, 79.42, 84.45, 86.46, 92.02, 95.03, 96.04, 98.36, 100.36, 103.56, 104.67],
	[0.66, 7.07, 15.1, 17.04, 22.99, 27.03, 31.54, 32.61, 43.3, 47.02, 50.27, 51.31, 53.24, 57.27, 60.15, 62.12, 64.24, 67.9, 71.68, 72.42, 75.45, 79.04, 80.05, 82.99, 87.54, 90.98, 95.32, 96.47, 99.04, 101.56, 104.13, 105.18],
	[0.73, 7.07, 11.01, 17.04, 19.13, 27.03, 31.17, 32.37, 33.34, 42.22, 43.82, 45.31, 47.28, 48.27, 49.29, 54.8, 56.24, 58.21, 59.88, 62.85, 63.92, 65.26, 67.33, 70.3, 71.33, 72.09, 73.06, 74.44, 76.45, 77.36, 82.38, 83.35, 87.31, 88.42, 89.31, 92.33, 94.4, 99.3, 102.5, 103.77, 104.97],
	[2.99, 15.1, 17.04, 22.99, 29.07, 31.76, 32.86, 41.04, 42.81, 46.25, 47.9, 52.26, 54.19, 55.24, 58.9, 61.25, 66.32, 68.35, 72.68, 73.52, 75.08, 80.43, 81.42, 84.01, 85.42, 90.34, 91.29, 93.41, 97.39, 99.95, 103.16, 104.34],
]
 
var score := 0

var note_texture = preload("res://images/note_sprite.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		await(2)
		pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
var song_ended := false

func _process(delta: float) -> void:
	queue_redraw()
	for i in 4:
		var lane = notes[i]
		while not lane.is_empty():
			var note = lane[0]
			if note < $Conductor.beat - 1:
				lane.pop_front()
				judgement_text.text = "MISS"
				if score >= 200:
					score -= 200
				if score < 200:
					score = 0
			else:
				break

	if not song_ended and _all_notes_cleared():
		song_ended = true
		await get_tree().create_timer(2.0).timeout
		end_screen.show()
		song_icon.show()
		score_text.text = "UPBEAT ROCK
COMPLETE!
SCORE: " + str(score) + "

GOING BACK TO SONG SELECTION"	
		await get_tree().create_timer(4.0).timeout

		_return_to_song_select()


func _all_notes_cleared() -> bool:
	for lane in notes:
		if not lane.is_empty():
			return false
	return true


func _return_to_song_select() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://song_selection.tscn")


func _draw() -> void:
	for i in 5:
		var start = Vector2(100 * i + 360, 0)
		var end = Vector2(100 * i + 360, 720)
		draw_line(start, end, Color.PURPLE)
		#if i < 4:
			#var label_pos = Vector2(100 * (i+0.5) + 360, 620 + 30)
			#draw_string(ThemeDB.fallback_font, label_pos, str(i+1), HORIZONTAL_ALIGNMENT_CENTER)

	var judge_start = Vector2(360, 620)
	var judge_end = Vector2(100 * 4 + 360, 620)
	draw_line(judge_start, judge_end, Color.HOT_PINK)
	for i in 4:    
		for note in notes[i]:
			var y = 620 + 150 * ($Conductor.beat - note)
			var rect = Rect2(100 * i + 360, y - 100 / 2, 100, 100)
			draw_texture_rect(note_texture, rect, false)
			
	draw_string(SCORE_FONT, Vector2(60, 60), "Score: " + str(score))

func _unhandled_key_input(event: InputEvent) -> void:
		if event.is_action_pressed("1"):
			_handle_lane_press(0)
		elif event.is_action_pressed("2"):
			_handle_lane_press(1)
		elif event.is_action_pressed("3"):
			_handle_lane_press(2)
		elif event.is_action_pressed("4"):
			_handle_lane_press(3)
		#elif event.is_action_pressed("5"):
			#_handle_lane_press(4)
		#elif event.is_action_pressed("6"):
			#_handle_lane_press(5)
		if event.is_action_pressed("toggle_record"):  # bind a new key in Input Map
			recording = not recording
			print("Recording: ", recording)

var recording := false
var recorded_notes := []  # will hold [lane, beat] pairs
func _handle_lane_press(lane: int) -> void:

	
	if recording:
		recorded_notes.append([lane, snappedf($Conductor.beat, 0.25)])
		print("Lane %d @ beat %.2f" % [lane, $Conductor.beat])
		return
	var lane_notes = notes[lane]
	if lane_notes.is_empty():
		return
	var note = lane_notes[0]

	if abs($Conductor.beat - note) < .6 && abs($Conductor.beat - note) > .200:
		lane_notes.pop_front()
		score+= 100	
		judgement_text.text = "GOOD"
	elif abs($Conductor.beat - note) < .200:
		lane_notes.pop_front()
		score += 250
		judgement_text.text = "PERFECT"
	elif abs($Conductor.beat - note) > .6 && abs($Conductor.beat - note) < 1:
		lane_notes.pop_front()
		score += 50
		judgement_text.text = "OKAY"
		
func _save_chart() -> void:
	var f = FileAccess.open("res://chart.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(recorded_notes))
	f.close()
	print("Chart saved with ", recorded_notes.size(), " notes")
func _unhandled_input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		$Conductor.start_song()
		click_text.text = " "
