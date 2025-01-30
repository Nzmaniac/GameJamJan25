extends Control



func _ready():
	var start_button = $VBoxContainer/StartButton
	var credits_button = $VBoxContainer/CreditsButton
	# Connect buttons to functions
	start_button.pressed.connect(_on_start_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world_manager.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits_scene.tscn")
