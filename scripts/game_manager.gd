# class_name GameStatManager
extends Node

signal stats_updated(stats: Array[Stat])
signal delivery_result(final_score: float, stat_scores: Dictionary)

var current_body_parts: Array[BodyPart] = []
var current_order: Order
@export var current_average_stats: Array[Stat] = []

var last_final_score: float = 0.0
var last_stat_scores: Dictionary = {}

func update_current_body_stats():
	var body_stats: Dictionary = calculate_body_stats(current_body_parts)
	current_average_stats = _dict_to_stat_array(body_stats)
	stats_updated.emit(current_average_stats)

func deliver_body():
	var body_stats: Dictionary = calculate_body_stats(current_body_parts)
	var stat_scores: Dictionary = calculate_stat_scores(body_stats, current_order)
	var final_score: float = calculate_stat_scores_average(stat_scores)
	
	last_final_score = final_score
	last_stat_scores = stat_scores
	
	delivery_result.emit(final_score, stat_scores)

func calculate_body_stats(body_parts: Array[BodyPart]) -> Dictionary:
	var totals := {}
	var counts := {}
	var averages := {}
	
	for stat in GameEnums.PersonalityStat.values():
		totals[stat] = 0.0
		counts[stat] = 0
		
	for body_part in body_parts:
		for stat_value in body_part.stats:
			totals[stat_value.stat] += stat_value.value
			counts[stat_value.stat] += 1
			
	for stat in GameEnums.PersonalityStat.values():
		if counts[stat] > 0:
			averages[stat] = totals[stat] / counts[stat]
			
	return averages

func calculate_stat_scores(body_stats: Dictionary, order: Order) -> Dictionary:
	var scores := {}
	
	for requirement in order.required_stats:
		if not body_stats.has(requirement.stat):
			scores[requirement.stat] = 0.0
			continue
			
		var actual: float = body_stats[requirement.stat]
		var required: float = requirement.value
		
		var difference : float = abs(actual - required)
		
		var percentage : float = clamp(
			100.0 - difference,
			0.0,
			100.0
		)

		scores[requirement.stat] = percentage

	return scores

func calculate_stat_scores_average(stat_scores: Dictionary) -> float:
	if stat_scores.is_empty():
		return 0.0

	var total: float = 0.0

	for score in stat_scores.values():
		total += score

	var average: float = total / stat_scores.size()

	return average
	
func _dict_to_stat_array(body_stats: Dictionary) -> Array[Stat]:
	var result: Array[Stat] = []
	for stat_type in GameEnums.PersonalityStat.values():
		var s := Stat.new()
		s.stat = stat_type
		s.value = body_stats.get(stat_type, 0.0)
		result.append(s)
	return result
