@tool

extends Window

@export var item_list: ItemList

func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	hide()

func _on_close_requested():
	hide()
