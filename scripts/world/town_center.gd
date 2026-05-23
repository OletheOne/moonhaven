extends Node2D

const MAP_WIDTH := 40
const MAP_HEIGHT := 30
const SOURCE_ID := 0

const TILE_COBBLE := Vector2i(0, 0)
const TILE_GRASS := Vector2i(1, 0)
const TILE_BUILDING := Vector2i(2, 0)
const TILE_FOUNTAIN := Vector2i(3, 0)
const TILE_ROAD := Vector2i(4, 0)
const TILE_LAMPPOST := Vector2i(5, 0)
const TILE_DECORATION := Vector2i(6, 0)

const BUILDING_SIZE := Vector2i(5, 5)
const FOUNTAIN_SIZE := 3

const ROAD_X_TILES: Array[int] = [19, 20]

const BUILDINGS: Array[Dictionary] = [
	{
		"name": "Pemberton Hall",
		"origin": Vector2i(6, 6),
		"door_cells": [Vector2i(8, 10)],
	},
	{
		"name": "Hearthfire Bakery",
		"origin": Vector2i(29, 6),
		"door_cells": [Vector2i(31, 10)],
	},
	{
		"name": "Apothecary",
		"origin": Vector2i(6, 19),
		"door_cells": [Vector2i(8, 19)],
	},
]

const FOUNTAIN_ORIGIN := Vector2i(19, 13)
const FOUNTAIN_COLLISION_CELL := Vector2i(20, 14)

const LAMPPOST_CELLS: Array[Vector2i] = [
	Vector2i(14, 12), Vector2i(25, 12), Vector2i(14, 17), Vector2i(25, 17),
	Vector2i(17, 8), Vector2i(22, 8), Vector2i(17, 22), Vector2i(22, 22),
]

const DECORATION_CELLS: Array[Vector2i] = [
	Vector2i(16, 11), Vector2i(23, 11), Vector2i(16, 18), Vector2i(23, 18),
	Vector2i(12, 14), Vector2i(27, 14), Vector2i(12, 16), Vector2i(27, 16),
]

@onready var ground_layer: TileMapLayer = $TileMap/Ground
@onready var decoration_layer: TileMapLayer = $TileMap/Decoration
@onready var collision_layer: TileMapLayer = $TileMap/Collision


func _ready() -> void:
	_build_town()


func _build_town() -> void:
	if ground_layer == null or decoration_layer == null or collision_layer == null:
		return

	ground_layer.clear()
	decoration_layer.clear()
	collision_layer.clear()

	for x in MAP_WIDTH:
		for y in MAP_HEIGHT:
			_set_tile(ground_layer, Vector2i(x, y), TILE_GRASS)

	_paint_town_plaza()
	_paint_north_road()
	_paint_fountain()
	_paint_buildings()
	_paint_lampposts()
	_paint_decorations()


func _paint_town_plaza() -> void:
	for x in range(14, 26):
		for y in range(11, 20):
			_set_tile(ground_layer, Vector2i(x, y), TILE_COBBLE)


func _paint_north_road() -> void:
	for y in range(0, 13):
		for road_x in ROAD_X_TILES:
			_set_tile(ground_layer, Vector2i(road_x, y), TILE_ROAD)


func _paint_fountain() -> void:
	for x in range(FOUNTAIN_ORIGIN.x, FOUNTAIN_ORIGIN.x + FOUNTAIN_SIZE):
		for y in range(FOUNTAIN_ORIGIN.y, FOUNTAIN_ORIGIN.y + FOUNTAIN_SIZE):
			var cell := Vector2i(x, y)
			_set_tile(decoration_layer, cell, TILE_FOUNTAIN)

	_set_tile(collision_layer, FOUNTAIN_COLLISION_CELL, TILE_FOUNTAIN)


func _paint_buildings() -> void:
	for building in BUILDINGS:
		var origin: Vector2i = building["origin"]
		var door_cells: Array = building["door_cells"]

		for x in range(origin.x, origin.x + BUILDING_SIZE.x):
			for y in range(origin.y, origin.y + BUILDING_SIZE.y):
				var cell := Vector2i(x, y)
				var is_door := cell in door_cells

				_set_tile(decoration_layer, cell, TILE_BUILDING)
				if not is_door:
					_set_tile(collision_layer, cell, TILE_BUILDING)


func _paint_lampposts() -> void:
	for cell in LAMPPOST_CELLS:
		if not _is_occupied(cell):
			_set_tile(decoration_layer, cell, TILE_LAMPPOST)


func _paint_decorations() -> void:
	for cell in DECORATION_CELLS:
		if not _is_occupied(cell):
			_set_tile(decoration_layer, cell, TILE_DECORATION)


func _is_occupied(cell: Vector2i) -> bool:
	if _is_fountain_cell(cell):
		return true

	for building in BUILDINGS:
		var origin: Vector2i = building["origin"]
		if (
			cell.x >= origin.x
			and cell.x < origin.x + BUILDING_SIZE.x
			and cell.y >= origin.y
			and cell.y < origin.y + BUILDING_SIZE.y
		):
			return true

	return false


func _is_fountain_cell(cell: Vector2i) -> bool:
	return (
		cell.x >= FOUNTAIN_ORIGIN.x
		and cell.x < FOUNTAIN_ORIGIN.x + FOUNTAIN_SIZE
		and cell.y >= FOUNTAIN_ORIGIN.y
		and cell.y < FOUNTAIN_ORIGIN.y + FOUNTAIN_SIZE
	)


func _set_tile(layer: TileMapLayer, cell: Vector2i, atlas_coords: Vector2i) -> void:
	layer.set_cell(cell, SOURCE_ID, atlas_coords)
