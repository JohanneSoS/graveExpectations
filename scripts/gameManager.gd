class_name GameManager
extends Node

var current_body_parts: Array[BodyPart] = []
var current_order: Order


func calculate_body_stats() -> Dictionary:
	var result := {}

	for stat in GameEnums.PersonalityStat.values():
		result[stat] = 0.0

	for part in current_body_parts:
		for stat_value in part.stats:
			result[stat_value.stat] += stat_value.value

	return result


func calculate_score() -> float:
	var body_stats := calculate_body_stats()

	var total_score := 0.0
	var number_of_requirements := current_order.required_stats.size()

	if number_of_requirements == 0:
		return 0.0

	for requirement in current_order.required_stats:
		var actual_value: float = body_stats.get(requirement.stat, 0.0)
		var required_value: float = requirement.value

		var difference := abs(actual_value - required_value)

		var stat_score := max(0.0, 100.0 - difference)

		total_score += stat_score

	return total_score / number_of_requirements
