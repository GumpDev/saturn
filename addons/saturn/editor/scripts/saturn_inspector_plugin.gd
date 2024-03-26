extends EditorInspectorPlugin

const SaturnStateMachineInspector = preload("res://addons/saturn/editor/scenes/state_machine_manager.tscn")

func _can_handle(object: Object) -> bool:
	return object is SaturnStatePlayer

func _parse_begin(object: Object) -> void:
	if object is SaturnStatePlayer:
		var saturn_state_player: SaturnStatePlayer = object
		var saturn_state_machine_inspector := SaturnStateMachineInspector.instantiate()
		saturn_state_machine_inspector.init(saturn_state_player)
		add_custom_control(saturn_state_machine_inspector)
