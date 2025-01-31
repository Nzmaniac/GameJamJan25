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
var scene_name = null
var correct_port_pairs = null



func _ready():
	# Connect signals for all ports
	for port in patch_panel_top.get_children() + patch_panel_bottom.get_children():
		port.pressed.connect(_on_port_pressed.bind(port))
		# Connect the Continue button signal
	continue_button.visible = false
	continue_button.disabled = true
	var current_scene = patch_panel_top.get_parent()
	print("Current scene filename:", current_scene.scene_file_path)
	scene_name = current_scene.name
	print("scene", current_scene.name)
	# Define the correct port pairs (top port name to bottom port name)
	if scene_name == "cabinet_mini_game":
		correct_port_pairs = {
			"Port_A1": "Port_B5"
		}
	elif scene_name == "cabinet2_mini_game":
		correct_port_pairs = {
			"Port_A3": "Port_A1"
		}
	elif scene_name == "cabinet3_mini_game":
		correct_port_pairs = {
			"Port_B6": "Port_B7"
		}
		
func _on_port_pressed(port):
	if not is_dragging:
		# Start the drag from the first port
		ModalManager.start_drag(port)
		is_dragging = true
	else:
		# Attempt to finalize the connection with the second port
		ModalManager.finalize_connection(port)
		is_dragging = false
