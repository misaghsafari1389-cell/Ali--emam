extends CharacterBase
class_name NPCBase

## Base class for all NPC characters
## Supports different roles, personalities, relationships, and daily behaviors

# NPC Identity
@export var npc_id: String = "npc_01"
@export var npc_role: String = "citizen"  # citizen, merchant, farmer, worker, etc.
@export var npc_faction: String = "neutral"

# NPC Relationships
var relationship_with_ali: float = 0.0  # -1.0 to 1.0
var relationships_with_npcs: Dictionary = {}  # NPC_ID: value

# Daily Schedule
var current_time_of_day: String = "day"  # morning, day, evening, night
var current_location: Vector3 = Vector3.ZERO
var home_location: Vector3 = Vector3.ZERO
var work_location: Vector3 = Vector3.ZERO

# Daily Activity Schedule
var daily_schedule: Dictionary = {
	"morning": "wake_up",
	"day": "work",
	"evening": "travel_home",
	"night": "sleep"
}

# NPC State
var is_idle: bool = true
var is_talking: bool = false
var is_working: bool = false
var trust_in_ali: float = 0.5

# Dialogue readiness
var dialogue_data: Dictionary = {}

func _ready() -> void:
	super._ready()
	print("[NPCBase] NPC initialized: %s (Role: %s)" % [npc_id, npc_role])

func set_role(new_role: String) -> void:
	## Change NPC role - same model, different role
	npc_role = new_role
	print("[NPCBase] %s role changed to: %s" % [npc_id, npc_role])

func set_personality_for_role(role_data: Dictionary) -> void:
	## Set personality based on role
	## Same NPC model can have different personalities in different roles
	if role_data.has("personality"):
		load_personality_data(role_data["personality"])
	if role_data.has("dialogue"):
		dialogue_data = role_data["dialogue"]

func update_relationship_with_ali(delta: float) -> void:
	## Update relationship value with Ali
	relationship_with_ali = clamp(relationship_with_ali + delta, -1.0, 1.0)
	print("[%s] Relationship with Ali: %.2f" % [npc_id, relationship_with_ali])

func get_daily_activity(time: String) -> String:
	## Get what NPC should be doing at this time
	return daily_schedule.get(time, "idle")

func set_daily_schedule(schedule: Dictionary) -> void:
	## Set custom daily schedule for this NPC
	daily_schedule = schedule

func is_available_for_interaction() -> bool:
	## Check if NPC is available to interact
	return is_idle and not is_working and not is_talking

func start_dialogue() -> void:
	is_talking = true
	set_behavior("talk")

func end_dialogue() -> void:
	is_talking = false
	set_behavior("idle")

func react_to_event(event_type: String) -> String:
	## NPC reacts to events based on personality
	var reaction = "ignore"
	
	match event_type:
		"ali_helping":
			if personality_profile.get_trait("kindness") > 0.5:
				reaction = "approve"
				update_relationship_with_ali(0.1)
		"ali_showing_courage":
			if personality_profile.get_trait("respect") > 0.6:
				reaction = "admire"
				update_relationship_with_ali(0.15)
		"ali_showing_honesty":
			if personality_profile.get_trait("trust") > 0.6:
				reaction = "trust"
				update_relationship_with_ali(0.1)
		"conflict_nearby":
			if personality_profile.get_trait("courage") > 0.6:
				reaction = "intervene"
			else:
				reaction = "avoid"
		"stranger_approach":
			if personality_profile.get_trait("sociability") > 0.6:
				reaction = "greet"
			else:
				reaction = "cautious"
	
	return reaction

func get_npc_summary() -> String:
	var summary = "=== NPC: %s ===\n" % npc_id
	summary += "Role: %s\n" % npc_role
	summary += "Importance: %s\n" % importance
	summary += "Relationship with Ali: %.2f\n" % relationship_with_ali
	summary += "Current Behavior: %s\n" % current_behavior
	summary += "Available: %s\n" % ("Yes" if is_available_for_interaction() else "No")
	summary += "\n" + personality_profile.get_personality_summary()
	return summary
