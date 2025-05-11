extends Node2D


@export var grid_height: int = 10
@export var grid_width: int = 10

@export var mine_count: int = 10
@onready var tile_scene = preload("res://tile.tscn")
@onready var grid = $BoardContainer/TileGrid

@onready var mine_counter = $MineCounter

var tiles = []

func _ready():
	create_board()
	place_mines()
	calculate_neighbors()
	update_mine_counter()
	
func create_board():
	tiles.clear()
	
	for child in grid.get_children():
		child.queue_free()
	grid.columns = grid_width
	
	for y in range(grid_height):
		for x in range(grid_width):
			var tile = tile_scene.instantiate()
			tile.x = x
			tile.y = y
			tile.main_script = self
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
		var neighbor_mines = get_neighbor_list(x, y).filter(func(nei): return nei.is_mine)
		tiles[i].neighbor_mines_count = neighbor_mines.size()
			
func try_reveal_neighbors(tile):
	if tile.neighbor_mines_count > 0:
		return
	for neighbor in get_neighbor_list(tile.x, tile.y):
		if not neighbor.is_revealed:
			if neighbor.is_flagged:
				neighbor.toggle_flag()
			neighbor.reveal()
			try_reveal_neighbors(neighbor)
			
func _on_tile_revealed(tile):
	if tile.is_mine:
		print("Game Over!")
	else:
		try_reveal_neighbors(tile)
			
func update_mine_counter():
	var flagged_tiles = tiles.filter(func(t): return t.is_flagged)
	var remaining_mines = mine_count - flagged_tiles.size()
	mine_counter.text = str(remaining_mines)
