class_name GameManager
extends Node

var current_body_parts: Array[BodyPart] = []
var current_order: Order

@export var current_average_stats: Array[Stat] = []

func update_current_body_stats():
	var body_stats: Dictionary = calculate_body_stats(current_body_parts)
	
	#here: assign the values to the ui

func deliver_body():
	var body_stats: Dictionary = calculate_body_stats(current_body_parts)
	
	var stat_scores: Dictionary = calculate_stat_scores(body_stats, current_order)
	
	var final_score: float = calculate_stat_scores_average(stat_scores)
	
	#here: display the values

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
