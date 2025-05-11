extends Node2D


@export var grid_height: int = 10
@export var grid_width: int = 5

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
	grid.columns = grid_width
	
	for y in range(grid_height):
		for x in range(grid_width):
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

func get_neighbor_list(x: int, y: int):
	var neighbors = []
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var nx = x + dx
			var ny = y + dy
			if nx >= 0 and ny >= 0 and nx < grid_width and ny < grid_height:
				var neighbor_index = ny * grid_width + nx
				neighbors.append(tiles[neighbor_index])
	return neighbors
	
func calculate_neighbors():
	for i in range(tiles.size()):
		var x = i % grid_width
		var y = i / grid_width
		var count = 0
		
		for neighbor in get_neighbor_list(x, y):
			if neighbor.is_mine:
				count += 1
		tiles[i].neighbor_mines_count = count
			
func _on_tile_revealed(tile):
	if tile.is_mine:
		print("Game Over!")
