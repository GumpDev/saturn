@tool
extends EditorPlugin

var saturn_state_machine_inspector: Control

func _enter_tree():
	saturn_state_machine_inspector = preload("res://addons/saturn/editor/scenes/state_machine_manager.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, saturn_state_machine_inspector)
	get_editor_interface().get_inspector().edited_object_changed.connect(func (): 
		var obj = get_editor_interface().get_inspector().get_edited_object()
		if obj is SaturnStatePlayer:
			saturn_state_machine_inspector.init(obj)
		else:
			saturn_state_machine_inspector.init(null)
	)

func _exit_tree():
	remove_control_from_docks(saturn_state_machine_inspector)
	pass
