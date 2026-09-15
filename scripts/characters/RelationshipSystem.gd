extends Node
class_name RelationshipSystem

## Relationship system between Ali and NPCs
## Tracks relationships, influences, and social dynamics

# Relationship types
const RELATIONSHIP_TYPES = [
	"stranger",
	"acquaintance",
	"friend",
	"trusted",
	"respected",
	"afraid",
	"uncomfortable",
	"hostile",
	"family"
]

# NPC relationship data
var npc_relationships: Dictionary = {}  # npc_id: relationship_data

# Ali's reputation tracking
var ali_reputation: Dictionary = {
	"amanah": 0,  # Trustworthiness
	"justice": 0,  # Justice and fairness
	"mercy": 0,  # Compassion
	"courage": 0,  # Bravery
	"loyalty": 0  # Loyalty to others
}

# Reputation thresholds
var reputation_thresholds: Dictionary = {
	"stranger_to_acquaintance": 3,
	"acquaintance_to_friend": 8,
	"friend_to_trusted": 15,
	"trusted_to_respected": 25
}

func _ready() -> void:
	print("[RelationshipSystem] Initialized")

func initialize_npc_relationship(npc_id: String, npc_data: Dictionary = {}) -> void:
	## Initialize relationship with NPC
	npc_relationships[npc_id] = {
		"npc_id": npc_id,
		"relationship_type": "stranger",
		"relationship_value": 0.0,  # -1.0 to 1.0
		"memory_points": [],  # Memorable interactions
		"personality_compatibility": calculate_personality_compatibility(npc_id),
		"has_helped_ali": false,
		"ali_has_helped": false,
		"interactions_count": 0,
		"last_interaction_time": 0.0
	}

func calculate_personality_compatibility(npc_id: String) -> float:
	## Calculate how compatible NPC personality is with Ali's
	## Higher = more compatible
	
	# This would be expanded with actual NPC personality data
	# For now, return a base compatibility
	return randf_range(0.3, 0.9)

func modify_relationship(npc_id: String, delta: float, reason: String = "") -> void:
	## Modify relationship with NPC
	if not npc_id in npc_relationships:
		initialize_npc_relationship(npc_id)
	
	var rel = npc_relationships[npc_id]
	rel["relationship_value"] = clamp(rel["relationship_value"] + delta, -1.0, 1.0)
	rel["interactions_count"] += 1
	rel["memory_points"].append({
		"time": Time.get_ticks_msec(),
		"delta": delta,
		"reason": reason
	})
	
	# Update relationship type based on value
	_update_relationship_type(npc_id)
	
	print("[RelationshipSystem] %s relationship modified: %s (Value: %.2f)" % [
		npc_id, 
		rel["relationship_type"], 
		rel["relationship_value"]
	])

func add_reputation(value_type: String, amount: int) -> void:
	## Add to Ali's reputation
	if value_type in ali_reputation:
		ali_reputation[value_type] += amount
		print("[RelationshipSystem] Ali's %s increased: %d" % [value_type, ali_reputation[value_type]])

func get_reputation_value(value_type: String) -> int:
	## Get specific reputation value
	return ali_reputation.get(value_type, 0)

func get_total_reputation() -> int:
	## Get total reputation score
	var total = 0
	for value in ali_reputation.values():
		total += value
	return total

func _update_relationship_type(npc_id: String) -> void:
	## Update relationship type based on value
	var rel = npc_relationships[npc_id]
	var value = rel["relationship_value"]
	
	if value < -0.6:
		rel["relationship_type"] = "hostile"
	elif value < -0.3:
		rel["relationship_type"] = "afraid"
	elif value < -0.1:
		rel["relationship_type"] = "uncomfortable"
	elif value < 0.1:
		rel["relationship_type"] = "stranger"
	elif value < 0.3:
		rel["relationship_type"] = "acquaintance"
	elif value < 0.5:
		rel["relationship_type"] = "friend"
	elif value < 0.7:
		rel["relationship_type"] = "trusted"
	else:
		rel["relationship_type"] = "respected"

func get_relationship_type(npc_id: String) -> String:
	## Get current relationship type
	if npc_id in npc_relationships:
		return npc_relationships[npc_id]["relationship_type"]
	return "stranger"

func get_relationship_value(npc_id: String) -> float:
	## Get relationship value
	if npc_id in npc_relationships:
		return npc_relationships[npc_id]["relationship_value"]
	return 0.0

func ali_helped_npc(npc_id: String) -> void:
	## Record that Ali helped this NPC
	if not npc_id in npc_relationships:
		initialize_npc_relationship(npc_id)
	
	var rel = npc_relationships[npc_id]
	rel["ali_has_helped"] = true
	modify_relationship(npc_id, 0.15, "Ali helped them")
	add_reputation("amanah", 1)

func npc_helped_ali(npc_id: String) -> void:
	## Record that NPC helped Ali
	if not npc_id in npc_relationships:
		initialize_npc_relationship(npc_id)
	
	var rel = npc_relationships[npc_id]
	rel["has_helped_ali"] = true
	modify_relationship(npc_id, 0.1, "They helped Ali")

func ali_showed_courage_to_npc(npc_id: String) -> void:
	## Record Ali showing courage
	modify_relationship(npc_id, 0.12, "Ali showed courage")
	add_reputation("courage", 1)

func ali_showed_mercy_to_npc(npc_id: String) -> void:
	## Record Ali showing mercy
	modify_relationship(npc_id, 0.15, "Ali showed mercy")
	add_reputation("mercy", 1)

func ali_showed_justice(npc_id: String) -> void:
	## Record Ali showing justice
	modify_relationship(npc_id, 0.2, "Ali showed justice")
	add_reputation("justice", 2)

func ali_showed_loyalty(npc_id: String) -> void:
	## Record Ali showing loyalty
	modify_relationship(npc_id, 0.18, "Ali showed loyalty")
	add_reputation("loyalty", 1)

func get_npc_reaction_to_ali(npc_id: String, npc_personality: PersonalityProfile) -> String:
	## Get NPC's reaction to Ali based on relationship
	var rel_type = get_relationship_type(npc_id)
	var personality = npc_personality
	
	match rel_type:
		"respected":
			return "admiring"
		"trusted":
			return "warm"
		"friend":
			return "friendly"
		"acquaintance":
			if personality.get_trait("kindness") > 0.7:
				return "polite"
			else:
				return "neutral"
		"stranger":
			if personality.get_trait("sociability") > 0.6:
				return "curious"
			else:
				return "cautious"
		"uncomfortable":
			return "wary"
		"afraid":
			return "fearful"
		"hostile":
			return "angry"
	
	return "neutral"

func get_all_relationships_summary() -> String:
	## Get summary of all relationships
	var summary = "=== ALL RELATIONSHIPS ===\n"
	summary += "Total Reputation: %d points\n" % get_total_reputation()
	summary += "  Amanah: %d\n" % ali_reputation["amanah"]
	summary += "  Justice: %d\n" % ali_reputation["justice"]
	summary += "  Mercy: %d\n" % ali_reputation["mercy"]
	summary += "  Courage: %d\n" % ali_reputation["courage"]
	summary += "  Loyalty: %d\n\n" % ali_reputation["loyalty"]
	
	summary += "=== NPC RELATIONSHIPS ===\n"
	for npc_id in npc_relationships:
		var rel = npc_relationships[npc_id]
		summary += "%s: %s (%.2f) - %d interactions\n" % [
			npc_id,
			rel["relationship_type"],
			rel["relationship_value"],
			rel["interactions_count"]
		]
	
	return summary

func get_npcs_by_relationship_type(rel_type: String) -> Array[String]:
	## Get all NPCs with specific relationship type
	var result: Array[String] = []
	for npc_id in npc_relationships:
		if npc_relationships[npc_id]["relationship_type"] == rel_type:
			result.append(npc_id)
	return result
