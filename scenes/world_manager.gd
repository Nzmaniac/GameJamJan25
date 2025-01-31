extends Node2D

@onready var timer_node = $TimerNode
@onready var clipboard = get_node("Clipboard/ClipboardUI")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_node.timeout.connect(_on_timer_timeout)
	timer_node.start()
	clipboard.update_timer_display(GlobalMenuManager.time_left)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout():
	print("Timer updating:", GlobalMenuManager.time_left)
	if GlobalMenuManager.time_left > 0:
		GlobalMenuManager.time_left -= 1  # ⏳ Decrease time by 1 second
		clipboard.update_timer_display(GlobalMenuManager.time_left)
		if GlobalMenuManager.time_left <= 10:
			print("less tahn 10")
			
