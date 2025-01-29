extends CharacterBody2D

var speed = 200
var map_bounds = Rect2(Vector2(0, 0), Vector2(1920, 1080))  # Define the map boundaries
var modal_scene = preload("res://scenes/cabinet_mini_game.tscn")
var is_controlling = true  # Player starts with control

@onready var cabinet = null
@onready var van = null  # Reference to the van
@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var collision_shape = $CollisionShape2D 

func _ready():
	# Find the van in the scene (adjust path if needed)
	van = get_node("../../Player_van/Van")  # Make sure this matches your scene structure
	cabinet = get_node("../../Cabinet")
	camera.make_current() # Make sure the player's camera is active at the start
	
func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	if input_dir.length() > 0:
		if input_dir.x > 0:  # Moving right
			animated_sprite.flip_h = false
			animated_sprite.play("walk-profile")
		elif input_dir.x < 0:  # Moving left
			animated_sprite.flip_h = true
			animated_sprite.play("walk-profile")
		elif input_dir.y > 0:  # Moving down
			animated_sprite.play("walk-front")
		elif input_dir.y < 0:  # Moving up
			animated_sprite.play("walk-back")
	else:
		animated_sprite.play("idle-front")  # Replace with your idle animation name
func _physics_process(delta):
	
	if is_controlling:
		collision_shape.disabled = false
		get_input()
		move_and_collide(velocity * delta)
		 # Clamp the position within the map boundaries
		global_position.x = clamp(global_position.x, map_bounds.position.x, map_bounds.position.x + map_bounds.size.x)
		global_position.y = clamp(global_position.y, map_bounds.position.y, map_bounds.position.y + map_bounds.size.y)
		if van and Input.is_action_just_pressed("interact") and is_near_van():
			enter_van()
		elif cabinet and Input.is_action_just_pressed("interact") and is_near_cabinet():
			print("minigame popup!")
			open_modal()

func is_near_van() -> bool:
	# Check if the player is close to the van (adjust distance as needed)
	print(global_position.distance_to(van.global_position))
	return global_position.distance_to(van.global_position) < 50
	
func enter_van():
	print("Entering van...")
	is_controlling = false  # Disable player control
	hide()  # Make the player disappear # Disable the player's camera
	collision_shape.disabled = true
	van.take_control(self)  # Call van's function to take control

func is_near_cabinet() -> bool:
	return global_position.distance_to(cabinet.global_position) < 50

func get_camera():
	return camera  # Helper function to get the player's camera

func open_modal():
	# Instance the modal
	var modal_instance = modal_scene.instantiate()
	if modal_instance is Control:
		var viewport_size = get_viewport_rect().size  # Get the size of the viewport
		var modal_size = modal_instance.size  # Get the size of the modal
		print("viewport: ", viewport_size)
		print("modal: ", modal_size)
		print("position: ", modal_instance.position)
		#modal_instance.position = (viewport_size - modal_size) / 2  # Center the modal
		modal_instance.z_index = 100

	
	# Add it to the current scene
	var ui_layer = get_node("../../../ModalContainer")
	ui_layer.add_child(modal_instance)  # Add as a child of the root viewport
	
	# Optionally, pause the game while the modal is open
	get_tree().paused = true  # Pause the game
	modal_instance.process_mode = Node.PROCESS_MODE_ALWAYS  # Ensure modal still processes while paused
	#print(modal_instance.get_parent())
	#print(modal_instance.global_position)
	#print(modal_instance.visible) 
	print("Modal opened!")
	
