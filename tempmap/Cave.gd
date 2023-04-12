extends Node

export(int) var map_width = 200
export(int) var map_height = 200
export(String) var world_seed = "Hello Godot!"
export(int) var noise_octaves = 5
export(int) var noise_period = 6
export(float) var noise_persistence = 0.5
export(float) var noise_lacunarity = 0.9
export(float) var noise_threshold = 0.001
export(bool) var redraw setget redraw

var tile_map : TileMap
var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()
var player : KinematicBody2D

func _ready() -> void:
	tile_map = get_parent() as TileMap
	clear()
	generate_square()
	generate()
	clear_area()


func clear_area():
	var player_pos = tile_map.world_to_map(get_node("/root/main/player").global_position)
	
	var clear_radius = 10
	for x in range(player_pos.x - clear_radius, player_pos.x + clear_radius):
		for y in range(player_pos.y - clear_radius, player_pos.y + clear_radius):
			tile_map.set_cell(x, y, -1)
	tile_map.update_dirty_quadrants()

func redraw(value = null) -> void:
	if tile_map == null:
		return
	clear()
	generate()
	clear_area()

func clear() -> void:
	tile_map.clear()

func generate() -> void:
	simplex_noise.seed = world_seed.hash()
	simplex_noise.octaves = noise_octaves
	simplex_noise.period = noise_period
	simplex_noise.persistence = noise_persistence
	simplex_noise.lacunarity = noise_lacunarity
	
	for x in range(-map_width / 2, map_width / 2):
		for y in range(-map_height / 2, map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < noise_threshold:
				_set_autotile(x, y) 
	_set_autotile(0, 0)
	tile_map.update_dirty_quadrants()

func generate_square() -> void:
	
	for x in range(-map_width / 2-1, map_width / 2+1):
		for y in range(-map_height / 2-1, map_height / 2+1):
			_set_autotile(x, y) 
	for x in range(-map_width / 2, map_width / 2):
		for y in range(-map_height / 2, map_height / 2):
			tile_map.set_cell(x, y, -1)


func _set_autotile(x : int, y : int) -> void:
	tile_map.set_cell(
		x,
		y,
		tile_map.get_tileset().get_tiles_ids()[0],
		false,
		false,
		false,
		tile_map.get_cell_autotile_coord(x, y)
	)
	tile_map.update_bitmask_area(Vector2(x, y))
