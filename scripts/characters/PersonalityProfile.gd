extends Resource
class_name PersonalityProfile

## Personality profile for characters
## Contains personality traits that influence behavior and reactions

var traits: Dictionary = {
	"kindness": 0.5,
	"honesty": 0.5,
	"patience": 0.5,
	"courage": 0.5,
	"sociability": 0.5,
	"seriousness": 0.5,
	"curiosity": 0.5,
	"trust": 0.5,
	"fear": 0.0,
	"respect": 0.5,
	"temper": 0.0,
	"generosity": 0.5
}

func _init(initial_traits: Dictionary = {}) -> void:
	if not initial_traits.is_empty():
		for trait in initial_traits:
			if trait in traits:
				traits[trait] = clamp(initial_traits[trait], 0.0, 1.0)

func get_trait(trait_name: String) -> float:
	## Get trait value (0.0 - 1.0)
	return traits.get(trait_name, 0.5)

func set_trait(trait_name: String, value: float) -> void:
	## Set trait value, clamped between 0.0 and 1.0
	if trait_name in traits:
		traits[trait_name] = clamp(value, 0.0, 1.0)

func get_all_traits() -> Dictionary:
	## Return all traits
	return traits.duplicate()

func load_from_dict(data: Dictionary) -> void:
	## Load personality from dictionary
	for trait in data:
		set_trait(trait, data[trait])

func to_dict() -> Dictionary:
	## Convert personality to dictionary
	return traits.duplicate()

func modify_trait(trait_name: String, delta: float) -> void:
	## Modify trait by delta amount
	if trait_name in traits:
		traits[trait_name] = clamp(traits[trait_name] + delta, 0.0, 1.0)

func get_reaction_intensity(situation: String) -> float:
	## Calculate reaction intensity based on personality traits
	## Different situations trigger different trait combinations
	match situation:
		"injustice":
			return (get_trait("courage") + get_trait("honesty")) / 2.0
		"helping_others":
			return (get_trait("kindness") + get_trait("generosity")) / 2.0
		"meeting_stranger":
			return get_trait("sociability")
		"dangerous_situation":
			return clamp(get_trait("courage") - get_trait("fear"), 0.0, 1.0)
		"conflict":
			return clamp(get_trait("patience") - get_trait("temper"), 0.0, 1.0)
		"learning":
			return get_trait("curiosity")
		_:
			return 0.5

func should_help(target_importance: String) -> bool:
	## Determine if character should help based on personality
	var kindness = get_trait("kindness")
	var generosity = get_trait("generosity")
	var help_chance = (kindness + generosity) / 2.0
	
	match target_importance:
		"child":
			help_chance += 0.2  # More likely to help children
		"elder":
			help_chance += 0.15  # More likely to help elders
		"stranger":
			help_chance -= 0.1  # Less likely to help strangers
	
	return randf() < clamp(help_chance, 0.0, 1.0)

func is_trustworthy() -> bool:
	## Determine if character is generally trustworthy
	return get_trait("honesty") > 0.6 and get_trait("kindness") > 0.5

func get_personality_summary() -> String:
	## Get a text summary of personality
	var summary = "Personality Profile:\n"
	for trait in traits:
		var value = traits[trait]
		var descriptor = "Neutral"
		if value > 0.7:
			descriptor = "Very High"
		elif value > 0.55:
			descriptor = "High"
		elif value < 0.3:
			descriptor = "Very Low"
		elif value < 0.45:
			descriptor = "Low"
		summary += "  %s: %s (%.2f)\n" % [trait.capitalize(), descriptor, value]
	return summary
