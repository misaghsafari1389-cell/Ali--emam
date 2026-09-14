extends Node
class_name NPCManager

## Manages all NPC instances, spawning, and interactions
## Data-driven NPC system

var npcs: Dictionary = {}  # npc_id: NPCBase instance
var npc_data: Dictionary = {}  # Loaded NPC data from JSON

var npc_scene: PackedScene
var active_npcs: Array[String] = []

func _ready() -> void:
	print("[NPCManager] Initialized")
	load_npc_data()
	_create_npc_scene_template()

func load_npc_data() -> void:
	## Load NPC data from JSON file
	var npc_file = "res://data/npc_personalities.json"
	if ResourceLoader.exists(npc_file):
		var json = JSON.new()
		var content = FileAccess.get_file_as_string(npc_file)
		json.parse(content)
		npc_data = json.data
		print("[NPCManager] Loaded NPC data: %d profiles" % npc_data.size())
	else:
		print("[NPCManager] Warning: NPC data file not found")

func _create_npc_scene_template() -> void:
	## Create a simple NPC scene template
	var scene = Scene3D.new()
	var npc_base = NPCBase.new()
	scene.add_child(npc_base)
	npc_scene = scene

func spawn_npc(npc_id: String, position: Vector3, parent: Node = null) -> NPCBase:
	## Spawn an NPC instance
	if npc_id in npcs:
		print("[NPCManager] NPC already spawned: %s" % npc_id)
		return npcs[npc_id]
	
	var npc = NPCBase.new()
	npc.npc_id = npc_id
	npc.global_position = position
	npc.home_location = position
	
	# Load NPC data if available
	if npc_id in npc_data:
		var data = npc_data[npc_id]
		npc.character_name = data.get("name", npc_id)
		npc.npc_role = data.get("role", "citizen")
		npc.importance = data.get("importance", "background")
		
		# Load personality
		if data.has("personality"):
			npc.load_personality_data(data["personality"])
		
		# Set daily schedule
		if data.has("daily_schedule"):
			npc.set_daily_schedule(data["daily_schedule"])
	
	# Add to scene
	if parent:
		parent.add_child(npc)
	
	npcs[npc_id] = npc
	active_npcs.append(npc_id)
	
	print("[NPCManager] Spawned NPC: %s at position: %s" % [npc_id, position])
	return npc

func despawn_npc(npc_id: String) -> void:
	## Remove NPC instance
	if npc_id in npcs:
		npcs[npc_id].queue_free()
		npcs.erase(npc_id)
		active_npcs.erase(npc_id)
		print("[NPCManager] Despawned NPC: %s" % npc_id)

func get_npc(npc_id: String) -> NPCBase:
	## Get NPC instance
	return npcs.get(npc_id, null)

func get_all_active_npcs() -> Array[String]:
	## Get list of all active NPC IDs
	return active_npcs

func update_npc_relationships(ali_character: PlayerCharacter) -> void:
	## Update all NPC relationships based on Ali's actions
	for npc_id in active_npcs:
		var npc = get_npc(npc_id)
		if npc:
			# Check Ali's reputation
			var ali_reputation = ali_character.get_reputation_score()
			var relationship_boost = ali_reputation * 0.01  # Scale down the boost
			npc.update_relationship_with_ali(relationship_boost)

func get_npcs_by_role(role: String) -> Array[NPCBase]:
	## Get all NPCs with specific role
	var result: Array[NPCBase] = []
	for npc_id in active_npcs:
		var npc = get_npc(npc_id)
		if npc and npc.npc_role == role:
			result.append(npc)
	return result

func get_npcs_by_importance(importance_level: String) -> Array[NPCBase]:
	## Get all NPCs with specific importance
	var result: Array[NPCBase] = []
	for npc_id in active_npcs:
		var npc = get_npc(npc_id)
		if npc and npc.importance == importance_level:
			result.append(npc)
	return result

func get_npcs_near_position(position: Vector3, radius: float) -> Array[NPCBase]:
	## Get all NPCs within radius of position
	var result: Array[NPCBase] = []
	for npc_id in active_npcs:
		var npc = get_npc(npc_id)
		if npc and npc.global_position.distance_to(position) <= radius:
			result.append(npc)
	return result

func print_all_npc_stats() -> void:
	## Debug: Print all NPC statistics
	print("\n=== ALL NPC STATISTICS ===")
	for npc_id in active_npcs:
		var npc = get_npc(npc_id)
		if npc:
			print(npc.get_npc_summary())
