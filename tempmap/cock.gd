extends Node

export(int) var map_width = 200
export(int) var map_height = 200
export(String) var world_seed = "Hello Godot!"
export(int) var noise_octaves = 6
export(int) var noise_period = 6
export(float) var noise_persistence = 0.5
export(float) var noise_lacunarity = 0.9
export(float) var noise_threshold = 0.002
export(bool) var redraw setget redraw

var tile_map : TileMap
var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()
var cell

func _ready() -> void:
	self.tile_map = get_parent() as TileMap
	clear()
	generate()
	

func redraw(value = null) -> void:
	if self.tile_map == null:
		return
	clear()
	generate()


func clear() -> void:
	self.tile_map.clear()

func generate() -> void:
	self.simplex_noise.seed = self.world_seed.hash()
	self.simplex_noise.octaves = self.noise_octaves
	self.simplex_noise.period = self.noise_period
	self.simplex_noise.persistence = self.noise_persistence
	self.simplex_noise.lacunarity = self.noise_lacunarity

	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if self.simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				self._set_autotile(x, y) 
	self._set_autotile(0, 0)
	self.tile_map.update_dirty_quadrants()

func _set_autotile(x : int, y : int) -> void:
	self.tile_map.set_cell(
		x,
		y,
		self.tile_map.get_tileset().get_tiles_ids()[0],
		false,
		false,
		false,
		self.tile_map.get_cell_autotile_coord(x, y)
	)
	self.tile_map.update_bitmask_area(Vector2(x, y))
