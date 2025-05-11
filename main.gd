extends Node2D


@export var grid_height: int = 10
@export var grid_width: int = 10
@export var mine_count: int = 10

@onready var board = $BoardContainer/Board
@onready var mine_counter = $MineCounter

var tiles = []

func _ready():
	board.main_script = self
	board.grid_height = grid_height
	board.grid_width = grid_width
	board.mine_count = mine_count
	board.init_game()
	update_mine_counter(0)
			
func update_mine_counter(flagged_mines: int):
	var remaining_mines = mine_count - flagged_mines
	mine_counter.text = str(remaining_mines)
