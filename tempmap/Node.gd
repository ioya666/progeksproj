extends Node


export var player_position = Vector2()

func _process(delta):
	player_position = get_node("Man").position

