extends Node
class_name BehaviorSystem

## Behavior system for characters
## Manages character behaviors and state transitions
## Separate from personality and model

# Available behaviors for childhood Ali (NO COMBAT)
const ALI_BEHAVIORS = [
	"idle",
	"look_around",
	"observe",
	"walk",
	"approach",
	"stop",
	"listen",
	"talk",
	"react",
	"help",
	"wait",
	"follow",
	"return",
	"protect",
	"show_concern"
]

# Available NPC behaviors
const NPC_BEHAVIORS = [
	"idle",
	"work",
	"walk",
	"talk",
	"listen",
	"react",
	"approach",
	"follow",
	"avoid",
	"help",
	"rest",
	"eat",
	"sleep"
]

var character_behaviors: Dictionary = {}  # character_id: current_behavior

func register_character(character_id: String, character: CharacterBase) -> void:
	## Register a character for behavior management
	character_behaviors[character_id] = {
		"character": character,
		"current_behavior": "idle",
		"behavior_timer": 0.0,
		"behavior_duration": 2.0
	}

func set_behavior(character_id: String, behavior: String) -> bool:
	## Set character behavior
	if not character_id in character_behaviors:
		return false
	
	var behavior_data = character_behaviors[character_id]
	var character = behavior_data["character"]
	
	# Validate behavior
	if character is PlayerCharacter:
		if behavior not in ALI_BEHAVIORS:
			print("[BehaviorSystem] Invalid behavior for Ali: %s" % behavior)
			return false
	elif character is NPCBase:
		if behavior not in NPC_BEHAVIORS:
			print("[BehaviorSystem] Invalid behavior for NPC: %s" % behavior)
			return false
	
	behavior_data["current_behavior"] = behavior
	behavior_data["behavior_timer"] = 0.0
	character.set_behavior(behavior)
	
	print("[BehaviorSystem] %s set to behavior: %s" % [character_id, behavior])
	return true

func get_behavior(character_id: String) -> String:
	## Get character's current behavior
	if character_id in character_behaviors:
		return character_behaviors[character_id]["current_behavior"]
	return "idle"

func update_behaviors(delta: float) -> void:
	## Update all character behaviors
	for character_id in character_behaviors:
		var behavior_data = character_behaviors[character_id]
		behavior_data["behavior_timer"] += delta
		
		# Behavior logic would go here
		# For now, behaviors are set manually

func is_behavior_allowed(character: CharacterBase, behavior: String) -> bool:
	## Check if behavior is valid for character type
	if character is PlayerCharacter:
		return behavior in ALI_BEHAVIORS
	elif character is NPCBase:
		return behavior in NPC_BEHAVIORS
	return false

func get_valid_behaviors(character: CharacterBase) -> Array[String]:
	## Get list of valid behaviors for character
	if character is PlayerCharacter:
		return ALI_BEHAVIORS
	elif character is NPCBase:
		return NPC_BEHAVIORS
	return []

func should_react_to_event(character: CharacterBase, event: String) -> bool:
	## Determine if character should react to event based on personality
	match event:
		"ali_helping":
			return character.personality_profile.get_trait("kindness") > 0.3
		"injustice":
			return character.personality_profile.get_trait("courage") > 0.3
		"stranger_approach":
			return character.personality_profile.get_trait("sociability") > 0.2
		_:
			return true
	return false

func calculate_reaction_type(character: CharacterBase, situation: String) -> String:
	## Calculate what type of reaction character should have
	var intensity = character.personality_profile.get_reaction_intensity(situation)
	
	if intensity > 0.7:
		return "strong"
	elif intensity > 0.4:
		return "moderate"
	elif intensity > 0.1:
		return "mild"
	else:
		return "none"

func _process(delta: float) -> void:
	update_behaviors(delta)
