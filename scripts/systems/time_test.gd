extends Node

@onready var status_label: Label = $CanvasLayer/StatusLabel


func _ready() -> void:
	print(Constants.GAME_TITLE)
	_update_status()

	TimeManager.minute_passed.connect(_on_minute_passed)
	TimeManager.day_started.connect(_on_day_started)


func _on_minute_passed() -> void:
	print("Tick")
	_update_status()


func _on_day_started() -> void:
	print("New day: %d" % TimeManager.day)
	_update_status()


func _update_status() -> void:
	status_label.text = (
		"%s\nDay %d %s, Year %d\nTime: %02d:%02d\nFrozen: %s\nPress F to toggle freeze"
		% [
			Constants.GAME_TITLE,
			TimeManager.day,
			TimeManager.season,
			TimeManager.year,
			TimeManager.hour,
			TimeManager.minute,
			str(TimeManager.is_frozen()),
		]
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		return

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F:
		if TimeManager.is_frozen():
			TimeManager.unfreeze()
			print("Time unpaused")
		else:
			TimeManager.freeze()
			print("Time paused")
		_update_status()
