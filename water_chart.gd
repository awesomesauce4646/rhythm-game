extends Node2D

@onready var judgement_text: RichTextLabel = $Judgement
@onready var click_text: RichTextLabel = $ClickToPlay

var notes = [
	[1.37, 3.99, 11.92, 14.76, 18.59, 19.69, 20.98, 22.79, 25.99, 28.46, 31.34, 33.37, 35.39, 41.95, 44.05, 46.73, 48.64, 52.5, 54.03, 59.36, 65.52, 68.04, 70.17, 73.67, 75.16, 78.23, 79.25, 85.79, 87.47, 89.99, 91.8, 92.72, 95.53, 96.4, 98.26, 99.67, 100.72, 101.85, 106.22, 107.82, 110.31, 112.51, 115.17, 117.85, 129.4, 132.02, 134.7, 135.77, 139.29, 143.62, 145.2, 146.33, 148.58, 149.48, 152.97, 153.71, 156.14, 159.29, 160.34, 163.41, 166.2],
	[2.16, 4.81, 6.51, 12.81, 15.59, 20.04, 21.26, 23.86, 27.17, 30.29, 31.95, 34.21, 36.28, 37.41, 41.04, 42.53, 45.39, 47.28, 49.62, 52.79, 55.13, 56.7, 57.7, 61.54, 66.63, 68.59, 71.27, 74.03, 76.32, 77.54, 78.94, 79.8, 80.99, 82.14, 85.16, 86.45, 88.97, 90.75, 93.51, 95.8, 97.1, 101.96, 103.3, 104.4, 106.77, 108.89, 111.46, 113.9, 117.24, 119.47, 123.96, 125.06, 130.1, 132.75, 135.48, 136.69, 138.5, 139.79, 142.55, 144.49, 146.06, 150.08, 151.63, 154.62, 157.19, 159.95, 160.84, 162.39, 164.96, 167.69],
	[2.84, 5.49, 7.61, 13.65, 16.44, 20.35, 21.56, 24.52, 26.62, 29.32, 31.72, 33.82, 36.04, 38.72, 42.29, 44.52, 47.02, 49.35, 53.22, 54.84, 57.42, 60.49, 65.82, 68.39, 70.93, 74.32, 75.71, 76.63, 80.44, 81.8, 84.95, 86.21, 88.31, 90.36, 92.54, 97.84, 100.41, 101.05, 106.47, 108.55, 111.2, 113.15, 117.5, 119.7, 121.23, 122.6, 124.77, 130.55, 133.12, 138.05, 139.52, 140.97, 141.94, 143.33, 144.85, 147.16, 149.9, 151.97, 154.35, 156.93, 159.63, 160.79, 162.65, 166.85, 168.08],
	[3.34, 11.19, 13.68, 14.36, 17.38, 20.64, 22.19, 23.02, 25.34, 27.91, 30.93, 32.69, 34.82, 36.78, 38.04, 39.02, 39.85, 41.53, 43.22, 46.07, 47.99, 50.46, 53.5, 56.02, 58.54, 64.77, 67.34, 69.47, 72.06, 74.69, 82.95, 85.45, 87.21, 89.75, 91.33, 96.16, 99.0, 102.51, 103.62, 105.37, 107.13, 109.65, 111.8, 114.25, 116.95, 118.55, 120.57, 121.99, 123.25, 125.87, 131.33, 133.93, 138.95, 140.23, 141.28, 143.85, 148.95, 150.81, 153.05, 155.43, 158.03, 161.58, 164.15, 165.38, 169.0],
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
				score -= 200
			else:
				break

	if not song_ended and _all_notes_cleared():
		song_ended = true
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
			
	draw_string(ThemeDB.fallback_font, Vector2(60, 60), "Score: " + str(score))

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
		judgement_text.text = "GOOD"
		score+= 100
	elif abs($Conductor.beat - note) < .200:
		lane_notes.pop_front()
		judgement_text.text = "PERFECT"
		score += 250
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
