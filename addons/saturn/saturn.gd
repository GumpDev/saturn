@tool
extends EditorPlugin

var saturn_inspector_plugin: EditorInspectorPlugin

func _enter_tree():
	saturn_inspector_plugin = preload("res://addons/saturn/editor/scripts/saturn_inspector_plugin.gd").new()
	add_inspector_plugin(saturn_inspector_plugin)
	pass


func _exit_tree():
	remove_inspector_plugin(saturn_inspector_plugin)
	pass
