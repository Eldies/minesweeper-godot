extends Node2D

@export var grid_size: int = 10
@export var mine_count: int = 10
@onready var tile_scene = preload("res://tile.tscn")
@onready var grid = $BoardContainer/TileGrid

var tiles = []

func _ready():
	create_board()
	place_mines()
	calculate_neighbors()
	
func create_board():
	tiles.clear()
	
	for child in grid.get_children():
		child.queue_free()
	
	for y in range(grid_size):
		for x in range(grid_size):
			var tile = tile_scene.instantiate()
			grid.add_child(tile)
			tile.connect("revealed", Callable(self, "_on_tile_revealed"))
			tiles.append(tile)
			
func place_mines():
	var mine_positions = []
	while len(mine_positions) < mine_count:
		var i = randi() % tiles.size()
		if i not in mine_positions:
			mine_positions.append(i)
			tiles[i].is_mine = true
				
func calculate_neighbors():
	for i in range(tiles.size()):
		var x = i % grid_size
		var y = i / grid_size
		var count = 0
			
		for dx in range(-1, 2):
			for dy in range(-1, 2):
				if dx == 0 and dy == 0:
					continue
				var nx = x + dx
				var ny = y + dy
				if nx >= 0 and ny >= 0 and nx < grid_size and ny < grid_size:
					var neighbor_index = ny * grid_size + nx
					if tiles[neighbor_index].is_mine:
						count += 1
		tiles[i].neighbor_mines_count = count
			
func _on_tile_revealed(tile):
	if tile.is_mine:
		print("Game Over!")
