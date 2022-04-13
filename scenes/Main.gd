extends Node


export (int) var level_width = 80
export (int) var level_height = 40

export (String) var noise_seed = "Seed"
export (float) var noise_threshold = 0

export (int) var noise_octaves = 3 setget set_octaves
export (int) var noise_period = 15 setget set_period
export (float) var noise_persistence = 0.5 setget set_persistence
export (float) var noise_lacunarity = 2.0 setget set_lacunarity


onready var tile_map: TileMap = $Level/TileMap
onready var background: ColorRect = $Level/ColorRect

onready var octaves_input: SpinBox = $UI/LevelGeneratorUI/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/BottomRow/Octave/Octaves
onready var period_input: SpinBox = $UI/LevelGeneratorUI/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/BottomRow/Period/NoisePeriod
onready var persistence_input: SpinBox = $UI/LevelGeneratorUI/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/BottomRow/Persistence/Persistence
onready var lacunarity_input: SpinBox = $UI/LevelGeneratorUI/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/BottomRow/Lacunarity/Lacunarity


var noise: OpenSimplexNoise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	randomize()
	generate_tilemap()


func generate_tilemap() -> void:
	# Setup the noise
	noise.seed = self.noise_seed.hash()
	noise.octaves = self.noise_octaves
	noise.period = self.noise_period
	noise.persistence = self.noise_persistence
	noise.lacunarity = self.noise_lacunarity
	
	# clear the tilemap
	clear_tilemap()

	# Go through our tiles and see if we draw there
	for x in range(-self.level_width / 2, self.level_width / 2):
		for y in range(-self.level_height / 2, self.level_height / 2):
			if noise.get_noise_2d(x, y) < self.noise_threshold:
				draw_tile(x, y)
	self.tile_map.update_dirty_quadrants()

# Draw a tile on the tilemap
func draw_tile(x: int, y: int) -> void:
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


func clear_tilemap() -> void:
	tile_map.clear()

# Totally randomize noise paramaters
func randomize_noise_params() -> void:
	var new_octaves = rng.randi_range(1, 9)
	var new_period = rand_range(1, 32)
	var new_persistence = rand_range(0, 1)
	var new_lacunarity = rand_range(0, 5)
	
	
	self.noise_octaves = new_octaves
	self.noise_period = new_period
	self.noise_persistence = new_persistence
	self.noise_lacunarity = new_lacunarity

# Slightly change noise parameters
func mutate_noise_params() -> void:
	var new_octaves = round(rng.randfn(self.noise_octaves, 2))
	var new_period = rng.randfn(self.noise_period, 2)
	var new_persistence = rng.randfn(self.noise_persistence, .2)
	var new_lacunarity = rng.randfn(self.noise_lacunarity, 2)
	
	
	self.noise_octaves = new_octaves
	self.noise_period = new_period
	self.noise_persistence = new_persistence
	self.noise_lacunarity = new_lacunarity


func set_octaves(value: int) -> void:
	noise_octaves = value
	octaves_input.value = value


func set_period(value: float) -> void:
	noise_period = value
	period_input.value = value


func set_persistence(value: float) -> void:
	noise_persistence = value
	persistence_input.value = value


func set_lacunarity(value: float) -> void:
	noise_lacunarity = value
	lacunarity_input.value = value


func set_level_height(height: int) -> void:
	self.level_height = height


func set_level_width(width: int) -> void:
	self.level_width = width


func _on_SeedEdit_text_entered(new_text: String) -> void:
	self.noise_seed = new_text
	generate_tilemap()


func _on_Threshold_value_changed(value: float) -> void:
	self.noise_threshold = value
	generate_tilemap()


func _on_NoisePeriod_value_changed(value: float) -> void:
	self.noise_period = value
	generate_tilemap()


func _on_Lacunarity_value_changed(value: float) -> void:
	self.noise_lacunarity = value
	generate_tilemap()


func _on_Octaves_value_changed(value: float) -> void:
	self.noise_octaves = value
	generate_tilemap()


func _on_Persistence_value_changed(value: float) -> void:
	self.noise_persistence = value
	generate_tilemap()


func _on_Height_value_changed(value: float) -> void:
	set_level_height(value)
	generate_tilemap()


func _on_Width_value_changed(value: float) -> void:
	set_level_width(value)
	generate_tilemap()


func _on_RandomizeParamsButton_pressed() -> void:
	randomize_noise_params()
	generate_tilemap()


func _on_MutateParamsButton_pressed() -> void:
	mutate_noise_params()
	generate_tilemap()
