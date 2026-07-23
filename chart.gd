extends Node2D
var notes = [
	[2, 7],
	[3, 8],
	[4, 9],
	[5, 10],
	[13, 18],
	[19, 20]
]
var score := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	for i in 6:
		var lane = notes[i]
		while not lane.is_empty():
			var note = lane[0]
			if note < $Conductor.beat - 0.5:
				lane.pop_front()
			else:
				break
	pass


func _draw() -> void:
	for i in 7:
		var start = Vector2(100 * i + 200, 0)
		var end = Vector2(100 * i + 200, 720)
		draw_line(start, end, Color.PURPLE)
		if i < 6:
			var label_pos = Vector2(100 * (i+0.5) + 200, 620 + 30)
			draw_string(ThemeDB.fallback_font, label_pos, str(i+1), HORIZONTAL_ALIGNMENT_CENTER)

	var judge_start = Vector2(200, 620)
	var judge_end = Vector2(100 * 6 + 200, 620)
	draw_line(judge_start, judge_end, Color.HOT_PINK)
	for i in 6:    
		for note in notes[i]:
			var y = 620 + 100 * ($Conductor.beat - note)
			var start = Vector2(100 * i + 200, y)
			var end = Vector2(100 * (i+1) + 200, y)
			draw_line(start, end, Color.WHITE, 20)
			
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
		elif event.is_action_pressed("5"):
			_handle_lane_press(4)
		elif event.is_action_pressed("6"):
			_handle_lane_press(5)


func _handle_lane_press(lane: int) -> void:
	var lane_notes = notes[lane]
	if lane_notes.is_empty():
		return
	var note = lane_notes[0]

	if abs($Conductor.beat - note) < .6 && abs($Conductor.beat - note) > .200:
		lane_notes.pop_front()
		score+= 100
	elif abs($Conductor.beat - note) < .200:
		lane_notes.pop_front()
		score += 250
