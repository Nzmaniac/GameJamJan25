extends Control  # This is now an AutoLoad singleton

var modal_instance  # Store modal reference
var is_dragging = false
var drag_start_position = Vector2.ZERO
var drag_start_port = null
var current_line = null  # Reference to the Line2D for drawing
var is_modal_active = false
var cabinet = null

func open_modal(cabinet_obj):

	if modal_instance:
		return
	cabinet = cabinet_obj
	if cabinet.name == "Cabinet":
		modal_instance = preload("res://scenes/cabinet_mini_game.tscn").instantiate()
	elif cabinet.name == "Cabinet2":
		modal_instance = preload("res://scenes/cabinet2_mini_game.tscn").instantiate()
	elif cabinet.name == "Cabinet3":
		modal_instance = preload("res://scenes/cabinet3_mini_game.tscn").instantiate()
	elif cabinet.name == "Cabinet4":
		modal_instance = preload("res://scenes/cabinet4_mini_game.tscn").instantiate()

	print(get_tree().root)
	var ui_layer = get_tree().root.get_node("world_manager/ModalContainer")
	ui_layer.add_child(modal_instance)

	modal_instance.process_mode = Node.PROCESS_MODE_ALWAYS

	# Center the modal dynamically above Player
	var player = get_node("../world_manager/Y_sort/Player")
	if player:
		var player_pos = player.global_position
		var modal_size = modal_instance.get_node("Background").size
		print("position ", cabinet.global_position)
		modal_instance.global_position = cabinet.global_position + Vector2(-modal_size.x / 2, -modal_size.y -5)  
	else:
		print("Player not found!")

	modal_instance.show()
	is_modal_active = true
	print("Modal opened at:", modal_instance.position)


func start_drag(port):
	if not modal_instance:
		return  

	is_dragging = true
	drag_start_port = port

	# Get the center of the port
	var port_size = port.get_rect().size
	var modal_global_position = modal_instance.global_position
	drag_start_position = port.global_position + (port_size / 2) - modal_global_position

	# Create a new line for patch lead
	current_line = Line2D.new()
	current_line.z_index = 30
	current_line.width = 3
	current_line.default_color = Color(1, 1, 0)
	modal_instance.add_child(current_line)

	print("Started drag at:", drag_start_position)
	
func _input(event):
	if modal_instance and is_dragging and event is InputEventMouseMotion:
		var local_mouse_pos = modal_instance.get_global_transform_with_canvas().affine_inverse() * event.position
		# Update the line drawing
		if current_line:
			current_line.clear_points()
			current_line.add_point(drag_start_position)
			current_line.add_point(local_mouse_pos)


func finalize_connection(end_port):
	if not is_dragging or not modal_instance:
		return  

	if drag_start_port == end_port:
		print("Cannot connect a port to itself.")
		modal_instance.cable_container.remove_child(current_line)  # Remove the incomplete cable
		current_line.queue_free()
		reset_drag()
		return
			
	var modal_global_position = modal_instance.global_position
	# Check if the end port is valid
	if end_port in modal_instance.patch_panel_bottom.get_children() and drag_start_port in modal_instance.patch_panel_top.get_children():
		print("Connected: ",modal_instance.patch_panel_top.name," ", drag_start_port.name, " to ",modal_instance.patch_panel_bottom.name," ", end_port.name)
		
		# Lock the line to the final position
		current_line.add_point(end_port.global_position + (end_port.get_rect().size / 2) - modal_global_position)  # Center of the end port
		
		# Add connectors to both ends
		add_connector(drag_start_position)
		add_connector(end_port.global_position + (end_port.get_rect().size / 2) - modal_global_position)
		# Check if the connection matches the correct pair
		if is_correct_connection(drag_start_port.name, end_port.name):
			print("Correct connection!")
			mark_off_task(cabinet.name)
			show_continue_button()
		# Reset drag state
		reset_drag()
	elif drag_start_port in modal_instance.patch_panel_bottom.get_children() and end_port in modal_instance.patch_panel_top.get_children():
		print("Connected: ",modal_instance.patch_panel_bottom.name," ", drag_start_port.name, " to ", modal_instance.patch_panel_top.name," ",end_port.name)

		# Lock the line to the final position
		current_line.add_point(end_port.global_position + (end_port.get_rect().size / 2) - modal_global_position)  # Center of the end port
		
		# Add connectors to both ends
		add_connector(drag_start_position)
		add_connector(end_port.global_position + (end_port.get_rect().size / 2) - modal_global_position)
		# Check if the connection matches the correct pair
		if is_correct_connection(end_port.name, drag_start_port.name):
			print("Correct connection!")
			mark_off_task(cabinet.name)
			show_continue_button()
		# Reset drag state
		reset_drag()
	elif drag_start_port in modal_instance.patch_panel_mid.get_children() and end_port in modal_instance.patch_panel_bottom.get_children():
		print("Connected: ",modal_instance.patch_panel_bottom.name," ", drag_start_port.name, " to ", modal_instance.patch_panel_top.name," ",end_port.name)

		# Lock the line to the final position
		current_line.add_point(end_port.global_position + (end_port.get_rect().size / 2) - modal_global_position)  # Center of the end port
		
		# Add connectors to both ends
		add_connector(drag_start_position)
		add_connector(end_port.global_position + (end_port.get_rect().size / 2) - modal_global_position)
		# Check if the connection matches the correct pair
		if is_correct_connection(end_port.name, drag_start_port.name):
			print("Correct connection!")
			mark_off_task(cabinet.name)
			show_continue_button()
		# Reset drag state
		reset_drag()
	elif drag_start_port in modal_instance.patch_panel_top.get_children() and end_port in modal_instance.patch_panel_mid.get_children():
		print("Connected: ",modal_instance.patch_panel_top.name," ", drag_start_port.name, " to ", modal_instance.patch_panel_mid.name," ",end_port.name)

		# Lock the line to the final position
		current_line.add_point(end_port.global_position + (end_port.get_rect().size / 2) - modal_global_position)  # Center of the end port
		
		# Add connectors to both ends
		add_connector(drag_start_position)
		add_connector(end_port.global_position + (end_port.get_rect().size / 2) - modal_global_position)
		# Check if the connection matches the correct pair
		if is_correct_connection( drag_start_port.name, end_port.name):
			print("Correct connection!")
			mark_off_task(cabinet.name)
			show_continue_button()
		# Reset drag state
		reset_drag()
	else:
		print("Invalid connection.")
		modal_instance.cable_container.remove_child(current_line)  # Remove the incomplete cable
		current_line.queue_free()
		reset_drag()
	# Reset dragging state
	is_dragging = false
	drag_start_port = null

func reset_drag():
	is_dragging = false
	drag_start_position = Vector2.ZERO
	drag_start_port = null
	current_line = null

func add_connector(position):
	# Create a new connector sprite
	var connector = Sprite2D.new()
	connector.texture = load("res://assets/cabinet_inner/connector.png")
	connector.z_index = 19
	connector.global_position = position
	 # Calculate the center position
	var port_size = Vector2(16, 16)  # Replace with your port's actual size
	var connector_texture_size = connector.texture.get_size()
	connector.scale = port_size / connector_texture_size  # Scale the connector
	
	# Add the connector to the container
	modal_instance.connectors_container.add_child(connector)

func is_correct_connection(start_port, end_port) -> bool:
	# Check if the connected ports match the correct pair
	return modal_instance.correct_port_pairs.get(start_port, "") == end_port

func show_continue_button():
	# Show and enable the Continue button
	if modal_instance:
		var continue_button = modal_instance.get_node("ContinueButton")
		continue_button.visible = true  # Make it visible
		continue_button.disabled = false
		continue_button.pressed.connect(close_modal)

func close_modal():
	if modal_instance:
		modal_instance.queue_free()
		modal_instance = null
		is_modal_active = false 

func mark_off_task(cabinet):
	var clipboard = get_tree().root.get_node("world_manager/Clipboard/ClipboardUI")
	if cabinet == "Cabinet":
		clipboard.complete_task("Cabinet 1 outside Yummart")
	elif cabinet == "Cabinet2":
		clipboard.complete_task("Cabinet 2 opp Barber Shop")
	elif cabinet == "Cabinet3":
		clipboard.complete_task("Cabinet 3 SW Housing block")
	elif cabinet == "Cabinet4":
		clipboard.complete_task("Cabinet 4 SE Housing block")
		
