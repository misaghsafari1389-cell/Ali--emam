extends CharacterBase
class_name PlayerCharacter

## Player character - Young Imam Ali
## Childhood version - NO WEAPONS, NO COMBAT
## Learn who Ali is through his actions

@export var ali_name: String = "Ali"
@export var ali_age: int = 10  # Childhood version

# Ali's core personality traits (data-driven)
var ali_personality_data: Dictionary = {
	"kindness": 0.85,
	"honesty": 0.95,
	"patience": 0.75,
	"courage": 0.80,
	"sociability": 0.70,
	"seriousness": 0.65,
	"curiosity": 0.90,
	"trust": 0.85,
	"fear": 0.10,
	"respect": 0.90,
	"temper": 0.05,
	"generosity": 0.80
}

# Ali's childhood behavior traits
var loyalty_level: float = 1.0  # Ali is extremely loyal
var protective_nature: float = 0.85  # Protective of others
var observant_level: float = 0.90  # Very observant
var responsible_level: float = 0.85  # Responsible

# Relationships
var relationships: Dictionary = {}  # NPC_ID: relationship_value

# Values/reputation tracking (will be expanded later)
var amanah_count: int = 0  # Trustworthiness actions
var justice_count: int = 0  # Justice actions
var mercy_count: int = 0  # Mercy actions
var courage_count: int = 0  # Courage actions
var loyalty_count: int = 0  # Loyalty actions

func _ready() -> void:
	character_name = ali_name
	character_id = "ali_child"
	importance = "story"
	
	# Load Ali's personality data
	load_personality_data(ali_personality_data)
	
	super._ready()
	
	print("[PlayerCharacter] Ali (Childhood) initialized")
	print(personality_profile.get_personality_summary())

func perform_action(action: String) -> void:
	## Track Ali's actions for character development
	match action:
		"help_someone":
			amanah_count += 1
			print("[Ali] Performed helpful action (Amanah: %d)" % amanah_count)
		"stand_for_justice":
			justice_count += 1
			print("[Ali] Stood for justice (Justice: %d)" % justice_count)
		"show_mercy":
			mercy_count += 1
			print("[Ali] Showed mercy (Mercy: %d)" % mercy_count)
		"act_courageously":
			courage_count += 1
			print("[Ali] Acted courageously (Courage: %d)" % courage_count)
		"remain_loyal":
			loyalty_count += 1
			print("[Ali] Remained loyal (Loyalty: %d)" % loyalty_count)

func set_relationship(npc_id: String, value: float) -> void:
	## Set relationship with NPC
	relationships[npc_id] = clamp(value, -1.0, 1.0)

func get_relationship(npc_id: String) -> float:
	## Get relationship value with NPC
	return relationships.get(npc_id, 0.0)

func modify_relationship(npc_id: String, delta: float) -> void:
	## Modify relationship with NPC
	var current = get_relationship(npc_id)
	set_relationship(npc_id, current + delta)

func is_observing() -> bool:
	## Ali observes his surroundings
	return observant_level > randf()

func is_protective_of(target_type: String) -> bool:
	## Check if Ali is protective in this situation
	match target_type:
		"child":
			return protective_nature > 0.7
		"elder":
			return protective_nature > 0.6
		"weak":
			return protective_nature > 0.5
		_:
			return protective_nature > randf()

func ali_childhood_behaviors() -> Array[String]:
	## List of Ali's childhood behaviors (NO COMBAT)
	return [
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

func get_reputation_score() -> int:
	## Calculate Ali's overall reputation
	return amanah_count + justice_count + mercy_count + courage_count + loyalty_count

func get_character_summary() -> String:
	var summary = "=== ALI (CHILDHOOD) ===\n"
	summary += "Age: %d\n" % ali_age
	summary += "Reputation: %d points\n" % get_reputation_score()
	summary += "  Amanah (Trust): %d\n" % amanah_count
	summary += "  Justice: %d\n" % justice_count
	summary += "  Mercy: %d\n" % mercy_count
	summary += "  Courage: %d\n" % courage_count
	summary += "  Loyalty: %d\n" % loyalty_count
	summary += "\n" + personality_profile.get_personality_summary()
	return summary
