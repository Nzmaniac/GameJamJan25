extends Control

var tasks = {
	"Cabinet 1 outside Yummart": false,
	"Cabinet 2 opp Barber Shop": false,
	"Cabinet 3 SW Housing block": false,
	"Cabinet 4 SE Housing block": false
}

var is_visible = true  # Start visible

func _ready():
	update_tasks()  # Populate tasks
	set_process_input(true)  # Ensure input is processed

func _input(event):
	if event.is_action_pressed("ui_focus_next"):  # "Tab" is mapped to `ui_focus_next`
		toggle_clipboard()

	if event.is_action_pressed("debug_complete_task"):  
		print("F pressed! Completing a task...")
		finish_random_task()


func toggle_clipboard():
	is_visible = !is_visible
	visible = is_visible

func update_tasks():
	var task_list = $TaskList

	for child in task_list.get_children():
		child.queue_free()

	await get_tree().process_frame  

	for task_text in tasks.keys():
		var task_container = Control.new()
		task_container.custom_minimum_size = Vector2(200, 30)  # Adjust task container size

		var task_label = Label.new()
		task_label.text = task_text
		#task_label.add_theme_font_override("font", load("res://path_to_your_font.tres"))
		task_label.add_theme_font_size_override("font_size", 16)
		task_label.add_theme_color_override("font_color", Color(0,0,0.3))

		# ✅ Create a custom strikethrough line
		var strike_through = ColorRect.new()
		strike_through.color = Color(0, 1, 0, 0.8)  # Green
		strike_through.custom_minimum_size = Vector2(220, 3)  # Thin line
		strike_through.position = Vector2(0, 16 / 2)  # Align over text
		strike_through.z_index = 10
		task_container.add_child(task_label)
		if tasks[task_text]:  
			print("added line")
			task_container.add_child(strike_through)  # ✅ Add line only if completed

		task_list.add_child(task_container)


func complete_task(task_name):
	if task_name in tasks:
		tasks[task_name] = true
		update_tasks()  # Refresh task list

func finish_random_task():
	for task_name in tasks.keys():
		if not tasks[task_name]:  # Find the first incomplete task
			tasks[task_name] = true
			print(task_name + " is now completed!")
			update_tasks()  # Refresh UI
			return
	print("All tasks are already completed!")

func are_all_tasks_completed() -> bool:
	for task_status in tasks.values():
		if not task_status:  # If any task is False (incomplete)
			return false  
	return true  # ✅ All tasks are complete
