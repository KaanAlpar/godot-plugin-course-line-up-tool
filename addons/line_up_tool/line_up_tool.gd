@tool
extends EditorPlugin

var lineup_ui
var undo_redo = null

func _enter_tree():
	undo_redo = get_undo_redo()
	
	lineup_ui = preload("res://addons/line_up_tool/line_up_ui.tscn").instantiate()
	lineup_ui.apply_button_pressed.connect(on_apply_button_pressed)
	
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, lineup_ui)

func _exit_tree():
	remove_control_from_docks(lineup_ui)
	lineup_ui.queue_free()

func on_apply_button_pressed(checkbutton_state, distance):
	if undo_redo == null:
		print("LineUpTool: Undo-redo manager is null!")
		return
	
	undo_redo.create_action("LineUpTool: Lined up the selected nodes.")
	
	var selected_nodes = EditorInterface.get_selection().get_selected_nodes()
	
	var first_node = selected_nodes[0]
	
	for i in range(1, selected_nodes.size()):
		var node = selected_nodes[i]
		if node is Node2D:
			var new_pos = first_node.global_position
			
			if checkbutton_state:
				new_pos.y += distance * i
			else:
				new_pos.x += distance * i
			
			#node.global_position = new_pos
			undo_redo.add_do_property(node, "global_position", new_pos)
			undo_redo.add_undo_property(node, "global_position", node.global_position)
	
	undo_redo.commit_action()






