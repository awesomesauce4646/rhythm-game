extends Node2D


func _on_play_water_pressed() -> void:
	get_tree().change_scene_to_file("res://water_song.tscn")


func _on_play_upbeat_pressed() -> void:
	get_tree().change_scene_to_file("res://upbeat_song.tscn")
