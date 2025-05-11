extends Button

signal revealed

var is_mine: bool = false
var neighbor_mines_count: int = 0
var is_revealed: bool = false
var is_flagged: bool = false

func _ready():
	text = ""
	disabled = false
	
func _pressed():
	if not is_flagged:
		emit_signal("revealed", self)
		reveal()
		
func reveal():
	if is_revealed or is_flagged:
		return
	
	is_revealed = true
	disabled = true
	
	if is_mine:
		text = "M"
	else:
		text = str(neighbor_mines_count)
		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		toggle_flag()

func toggle_flag():
	if is_revealed:
		return
		
	is_flagged = not is_flagged
	text = "F" if is_flagged else ""
	
