extends Window

@onready var item_list: ItemList = $ItemList

signal button_clicked(index: int)

func _ready():
	item_list.item_clicked.connect(func (index: int, at_position: Vector2, mouse_button_index: int): 
		button_clicked.emit(index)
		hide()
	)
	close_requested.connect(func ():
		button_clicked.emit(-1)
		hide()
	)
	
	hide()

func show_window(pos: Vector2):
	position = pos
	show()
