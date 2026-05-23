extends Node

signal minute_passed
signal hour_passed
signal day_started
signal day_ended
signal season_changed

const SEASONS: Array[String] = ["Spring", "Summer", "Autumn", "Winter"]
const DAYS_PER_SEASON := 28

var hour: int = Constants.STARTING_HOUR
var minute: int = 0
var day: int = Constants.STARTING_DAY
var season: String = Constants.STARTING_SEASON
var year: int = Constants.STARTING_YEAR

var _frozen := false
var _accumulator := 0.0


func _ready() -> void:
	reset_to_start()


func reset_to_start() -> void:
	hour = Constants.STARTING_HOUR
	minute = 0
	day = Constants.STARTING_DAY
	season = Constants.STARTING_SEASON
	year = Constants.STARTING_YEAR
	_accumulator = 0.0
	_frozen = false


func _process(delta: float) -> void:
	if _frozen:
		return

	_accumulator += delta
	while _accumulator >= Constants.REAL_SECONDS_PER_GAME_MINUTE:
		_accumulator -= Constants.REAL_SECONDS_PER_GAME_MINUTE
		_advance_minute()


func freeze() -> void:
	_frozen = true


func unfreeze() -> void:
	_frozen = false


func is_frozen() -> bool:
	return _frozen


func advance_to(target_hour: int, target_minute: int) -> void:
	if target_hour < hour or (target_hour == hour and target_minute <= minute):
		_roll_day()

	hour = target_hour
	minute = target_minute


func _advance_minute() -> void:
	minute += 1
	if minute >= 60:
		minute = 0
		_advance_hour()
	minute_passed.emit()


func _advance_hour() -> void:
	hour += 1
	hour_passed.emit()

	if hour >= 24:
		hour = 0
		_roll_day()


func _roll_day() -> void:
	day_ended.emit()
	day += 1

	if day > DAYS_PER_SEASON:
		day = 1
		_advance_season()

	day_started.emit()


func _advance_season() -> void:
	var season_index := SEASONS.find(season)
	season_index += 1

	if season_index >= SEASONS.size():
		season_index = 0
		year += 1

	season = SEASONS[season_index]
	season_changed.emit()
