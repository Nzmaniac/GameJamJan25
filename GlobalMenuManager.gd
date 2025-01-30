extends Node

var exit_dialog = null

func _input(event):
	if event.is_action_pressed("ui_cancel"):  
		if not exit_dialog:
			show_exit_dialog()

func show_exit_dialog():
	exit_dialog = AcceptDialog.new()
	exit_dialog.dialog_text = "Return to Main Menu?"
	exit_dialog.size = Vector2(400, 200)
	exit_dialog.add_button("Cancel", false, "cancel")
	exit_dialog.ok_button_text = "Yes"

	# Connect "confirmed" signal to return to the main menu
	exit_dialog.confirmed.connect(_return_to_main_menu)

	# Use "visibility_changed" instead of "popup_hide"
	exit_dialog.visibility_changed.connect(_on_exit_dialog_closed)

	# Add the dialog to the scene and show it
	get_tree().root.add_child(exit_dialog)
	exit_dialog.popup_centered()

func _on_exit_dialog_closed():
	# If the dialog is no longer visible, free it
	if exit_dialog and not exit_dialog.visible:
		exit_dialog.queue_free()
		exit_dialog = null  # Reset reference
	   
func _return_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/splash_screen.tscn")
