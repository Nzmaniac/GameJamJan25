extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "man-1":  # ✅ Only trigger when player enters
		print("🏠 Player arrived home! Checking tasks...")

		var clipboard = get_node("../Clipboard/ClipboardUI")

		if clipboard.are_all_tasks_completed():
			print("✅ All tasks are complete! Player can enter home.")
			allow_player_entry(body)
			
		else:
			print("❌ Some tasks are incomplete! You cannot go home yet.")

func allow_player_entry(player):
	var timer = get_node("../TimerNode")
	timer.stop()
	print("🚪 Player is entering home...")
	player.position = Vector2(100, 100)  # Example: Move player inside
	call_deferred("_change_to_end_scene")

func _change_to_end_scene():
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
