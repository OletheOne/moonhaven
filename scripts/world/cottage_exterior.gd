@tool
extends Node2D

const MAP_SIZE := 30
const SOURCE_ID := 0

const TILE_GRASS := Vector2i(0, 0)
const TILE_COTTAGE := Vector2i(1, 0)
const TILE_DIRT := Vector2i(2, 0)
const TILE_ROAD := Vector2i(3, 0)
const TILE_TREE := Vector2i(4, 0)
const TILE_DECORATION := Vector2i(5, 0)

const COTTAGE_ORIGIN := Vector2i(12, 10)
const COTTAGE_SIZE := Vector2i(6, 5)
const DOOR_CELLS: Array[Vector2i] = [Vector2i(14, 14), Vector2i(15, 14)]

const FARM_ORIGIN := Vector2i(5, 12)
const FARM_SIZE := 5

const ROAD_X_TILES: Array[int] = [14, 15]

@onready var ground_layer: TileMapLayer = $TileMap/Ground
@onready var decoration_layer: TileMapLayer = $TileMap/Decoration
@onready var collision_layer: TileMapLayer = $TileMap/Collision
@onready var door_zone: Area2D = $DoorZone


func _ready() -> void:
	_build_exterior()

	if not Engine.is_editor_hint():
		door_zone.body_entered.connect(_on_door_zone_body_entered)


func _build_exterior() -> void:
	if ground_layer == null or decoration_layer == null or collision_layer == null:
		return

	ground_layer.clear()
	decoration_layer.clear()
	collision_layer.clear()

	for x in MAP_SIZE:
		for y in MAP_SIZE:
			_set_tile(ground_layer, Vector2i(x, y), TILE_GRASS)

	_paint_farm_plot()
	_paint_road()
	_paint_cottage()
	_paint_edge_trees()
	_paint_edge_decorations()


func _paint_farm_plot() -> void:
	for x in FARM_ORIGIN.x until FARM_ORIGIN.x + FARM_SIZE:
		for y in FARM_ORIGIN.y until FARM_ORIGIN.y + FARM_SIZE:
			_set_tile(ground_layer, Vector2i(x, y), TILE_DIRT)


func _paint_road() -> void:
	for y in COTTAGE_ORIGIN.y + COTTAGE_SIZE.y - 1 until MAP_SIZE:
		for road_x in ROAD_X_TILES:
			_set_tile(ground_layer, Vector2i(road_x, y), TILE_ROAD)


func _paint_cottage() -> void:
	for x in COTTAGE_ORIGIN.x until COTTAGE_ORIGIN.x + COTTAGE_SIZE.x:
		for y in COTTAGE_ORIGIN.y until COTTAGE_ORIGIN.y + COTTAGE_SIZE.y:
			var cell := Vector2i(x, y)
			var is_door := cell in DOOR_CELLS

			_set_tile(decoration_layer, cell, TILE_COTTAGE)
			if not is_door:
				_set_tile(collision_layer, cell, TILE_COTTAGE)


func _paint_edge_trees() -> void:
	for x in MAP_SIZE:
		_set_tree(Vector2i(x, 0))
		_set_tree(Vector2i(x, MAP_SIZE - 1))

	for y in range(1, MAP_SIZE - 1):
		_set_tree(Vector2i(0, y))
		_set_tree(Vector2i(MAP_SIZE - 1, y))


func _paint_edge_decorations() -> void:
	var decoration_spots: Array[Vector2i] = [
		Vector2i(2, 2), Vector2i(27, 2), Vector2i(2, 27), Vector2i(27, 27),
		Vector2i(8, 3), Vector2i(22, 6), Vector2i(3, 20), Vector2i(26, 22),
	]

	for spot in decoration_spots:
		if not _is_cottage_cell(spot) and not _is_farm_cell(spot):
			_set_tile(decoration_layer, spot, TILE_DECORATION)


func _set_tree(cell: Vector2i) -> void:
	_set_tile(decoration_layer, cell, TILE_TREE)
	_set_tile(collision_layer, cell, TILE_TREE)


func _is_cottage_cell(cell: Vector2i) -> bool:
	return (
		cell.x >= COTTAGE_ORIGIN.x
		and cell.x < COTTAGE_ORIGIN.x + COTTAGE_SIZE.x
		and cell.y >= COTTAGE_ORIGIN.y
		and cell.y < COTTAGE_ORIGIN.y + COTTAGE_SIZE.y
	)


func _is_farm_cell(cell: Vector2i) -> bool:
	return (
		cell.x >= FARM_ORIGIN.x
		and cell.x < FARM_ORIGIN.x + FARM_SIZE
		and cell.y >= FARM_ORIGIN.y
		and cell.y < FARM_ORIGIN.y + FARM_SIZE
	)


func _set_tile(layer: TileMapLayer, cell: Vector2i, atlas_coords: Vector2i) -> void:
	layer.set_cell(cell, SOURCE_ID, atlas_coords)


func _on_door_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Cottage door zone entered")
