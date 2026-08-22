class_name LevelGenerator
extends Node

@export var order: Order
@export var spawn_areas: Array[SpawnArea] = []
@export var min_stats_per_part: int = 1
@export var max_stats_per_part: int = 4

func generate_level():
	var slots: Array = []
	for area in spawn_areas:
		for i in area.slot_count:
			var stat_array: Array[Stat] = []
			slots.append({"area": area, "stats": stat_array})

	for req in order.required_stats:
		var pool = slots.duplicate()
		pool.shuffle()
		var contributor_count = randi_range(1, pool.size())
		pool = pool.slice(0, contributor_count)

		var portions = _split_value(req.value, contributor_count)
		for i in pool.size():
			var s = Stat.new()
			s.stat = req.stat
			s.value = portions[i]
			pool[i]["stats"].append(s)

	var area_solutions: Dictionary = {}
	for area in spawn_areas:
		var parts_array: Array[BodyPart] = []
		area_solutions[area] = parts_array
	for slot in slots:
		area_solutions[slot["area"]].append(_build_solution_part(slot["stats"], slot["area"].body_part_type))

	for area in spawn_areas:
		area.spawn_with_guaranteed_solutions(area_solutions[area])

func _split_value(total: float, count: int) -> Array[float]:
	var weights: Array[float] = []
	for i in count:
		weights.append(randf_range(0.1, 1.0))
	var weight_sum: float = weights.reduce(func(a, b): return a + b, 0.0)
	var portions: Array[float] = []
	for w in weights:
		portions.append(clamp(total * (w / weight_sum), 0.0, 100.0))
	return portions

func _build_solution_part(required_contribs: Array[Stat], part_type: GameEnums.BodyPartType) -> BodyPart:
	var part = BodyPart.new()
	part.body_part_type = part_type
	part.stats = required_contribs.duplicate(true)

	var target_count = randi_range(min_stats_per_part, max_stats_per_part)
	var used_types: Array = required_contribs.map(func(s): return s.stat)

	while part.stats.size() < target_count:
		var t = GameEnums.PersonalityStat.values().pick_random()
		if t in used_types:
			continue
		var filler = Stat.new()
		filler.stat = t
		filler.value = randf_range(0.0, 100.0)
		part.stats.append(filler)
		used_types.append(t)

	return part

func check_order_fulfilled(assembled_parts: Array[BodyPart]) -> bool:
	var totals: Dictionary = {}
	for part in assembled_parts:
		for stat in part.stats:
			totals[stat.stat] = totals.get(stat.stat, 0.0) + stat.value
	for req in order.required_stats:
		if totals.get(req.stat, 0.0) < req.value:
			return false
	return true
