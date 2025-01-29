extends Control

@onready var cable_container = $CableContainer
@onready var connectors_container = $ConnectorsContainer
@onready var patch_panel_top = $PatchPanelTop
@onready var patch_panel_bottom = $PatchPanelBottom
@onready var continue_button = $ContinueButton

var drag_start_position = Vector2.ZERO
var drag_start_port = null  # The port the drag started from
var is_dragging = false
var current_line = null  # Reference to the currently drawn line

# Define the correct port pairs (top port name to bottom port name)
var correct_port_pairs = {
	"Port_A1": "Port_B5"
}
func _ready():
	# Connect signals for all ports
	for port in patch_panel_top.get_children() + patch_panel_bottom.get_children():
		port.pressed.connect(_on_port_pressed.bind(port))
		# Connect the Continue button signal
	continue_button.pressed.connect(_on_continue_pressed)
	$ContinueButton.visible = false
	$ContinueButton.disabled = true


func _on_port_pressed(port):
	if not is_dragging:
		# Start the drag from the first port
		start_drag(port)
	else:
		# Attempt to finalize the connection with the second port
		finalize_connection(port)

func _input(event):
	if is_dragging and event is InputEventMouseMotion:
		# Update the dragging line as the mouse moves
		current_line.clear_points()
		print("_input drag start pos: ", drag_start_position)
		current_line.add_point(drag_start_position)  # Start point
		current_line.add_point(event.position)  # Current mouse position

func start_drag(port):
	is_dragging = true
	# Get the center of the port
	var port_size = port.size
	drag_start_position = (port.global_position + port_size / 2)  # Center of the port
	
	print("drag start position: ", drag_start_position)
	print("port_name", port.global_position)
	drag_start_port = port


	# Create a new Line2D for this cable
	current_line = Line2D.new()
	current_line.clear_points()
	current_line.add_point(drag_start_position) 
	current_line.z_index = 30
	current_line.width = 3
	current_line.default_color = Color(1, 1, 0)  # Blue color for the cable
	cable_container.add_child(current_line)  # Add the line to the container


func finalize_connection(end_port):
	if drag_start_port == end_port:
		# Prevent connecting a port to itself
		print("Cannot connect a port to itself.")
		cable_container.remove_child(current_line)  # Remove the incomplete cable
		current_line.queue_free()
		reset_drag()
		return
	var modal_global_position = global_position
	# Check if the end port is valid
	if end_port in patch_panel_bottom.get_children() and drag_start_port in patch_panel_top.get_children():
		print("Connected: ",patch_panel_top.name," ", drag_start_port.name, " to ",patch_panel_bottom.name," ", end_port.name)

		# Lock the line to the final position
		current_line.add_point(end_port.global_position + end_port.size / 2)  # Center of the end port
		
		# Add connectors to both ends
		add_connector(drag_start_position)
		add_connector((end_port.global_position + end_port.size / 2) - modal_global_position)
		# Check if the connection matches the correct pair
		if is_correct_connection(drag_start_port.name, end_port.name):
			print("Correct connection!")
			show_continue_button()
		# Reset drag state
		reset_drag()
	elif drag_start_port in patch_panel_bottom.get_children() and end_port in patch_panel_top.get_children():
		print("Connected: ",patch_panel_bottom.name," ", drag_start_port.name, " to ", patch_panel_top.name," ",end_port.name)

		# Lock the line to the final position
		current_line.add_point(end_port.global_position + end_port.size / 2)  # Center of the end port

		# Add connectors to both ends
		add_connector(drag_start_position)
		add_connector((end_port.global_position + end_port.size / 2) - modal_global_position)
		# Check if the connection matches the correct pair
		if is_correct_connection(end_port.name, drag_start_port.name):
			print("Correct connection!")
			show_continue_button()
		# Reset drag state
		reset_drag()
	else:
		print("Invalid connection.")
		cable_container.remove_child(current_line)  # Remove the incomplete cable
		current_line.queue_free()
		reset_drag()

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
	connectors_container.add_child(connector)

func is_correct_connection(start_port, end_port) -> bool:
	# Check if the connected ports match the correct pair
	return correct_port_pairs.get(start_port, "") == end_port

func show_continue_button():
	# Show and enable the Continue button
	continue_button.visible = true
	continue_button.disabled = false

func _on_continue_pressed():
	# Close the modal when the Continue button is pressed
	print("Continue button pressed. Closing modal.")
	queue_free()  # Removes this modal from the scene
