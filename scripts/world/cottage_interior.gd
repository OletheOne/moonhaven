@tool
extends Node2D

const ROOM_WIDTH := 12
const ROOM_HEIGHT := 10
const SOURCE_ID := 0

const TILE_FLOOR := Vector2i(0, 0)
const TILE_WALL := Vector2i(1, 0)
const TILE_BED := Vector2i(2, 0)
const TILE_HEARTH := Vector2i(3, 0)
const TILE_DOOR := Vector2i(4, 0)
const TILE_CHEST := Vector2i(5, 0)

const DOOR_CELLS: Array[Vector2i] = [Vector2i(5, 9), Vector2i(6, 9)]

@onready var floor_layer: TileMapLayer = $TileMap/Floor
@onready var walls_layer: TileMapLayer = $TileMap/WallsDecoration
@onready var collision_layer: TileMapLayer = $TileMap/Collision
@onready var exit_zone: Area2D = $ExitZone


func _ready() -> void:
	_build_room()

	if not Engine.is_editor_hint():
		exit_zone.body_entered.connect(_on_exit_zone_body_entered)


func _build_room() -> void:
	if floor_layer == null or walls_layer == null or collision_layer == null:
		return

	floor_layer.clear()
	walls_layer.clear()
	collision_layer.clear()

	for x in ROOM_WIDTH:
		for y in ROOM_HEIGHT:
			var cell := Vector2i(x, y)
			var is_border := x == 0 or x == ROOM_WIDTH - 1 or y == 0 or y == ROOM_HEIGHT - 1
			var is_door := cell in DOOR_CELLS

			if is_border and not is_door:
				_set_tile(walls_layer, cell, TILE_WALL)
				_set_tile(collision_layer, cell, TILE_WALL)
			elif not is_border:
				_set_tile(floor_layer, cell, TILE_FLOOR)

	_set_tile(walls_layer, Vector2i(1, 1), TILE_BED)
	_set_tile(walls_layer, Vector2i(10, 6), TILE_HEARTH)
	_set_tile(walls_layer, Vector2i(2, 4), TILE_CHEST)

	for door_cell in DOOR_CELLS:
		_set_tile(walls_layer, door_cell, TILE_DOOR)


func _set_tile(layer: TileMapLayer, cell: Vector2i, atlas_coords: Vector2i) -> void:
	layer.set_cell(cell, SOURCE_ID, atlas_coords)


func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Door zone entered")
