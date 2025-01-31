extends Control



func _ready():
	var time_left = GlobalMenuManager.time_left
	var minutes = time_left / 60
	var seconds = time_left % 60
	$TimeRemainAmt.text = "%02d:%02d" % [minutes, seconds]  # ✅ Format as MM:SS
	$EndButton.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/splash_screen.tscn")
