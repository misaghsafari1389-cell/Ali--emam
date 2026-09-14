extends Node3D
class_name CharacterBase

## Base class for all characters (Player and NPC)
## Modular design: Model, Animation, Movement, Personality are separate

@export var character_name: String = "Character"
@export var character_id: String = "char_base"
@export var importance: String = "background"  # background, minor, important, story
@export var model_path: String = ""  # Path to GLB/GLTF model (will be assigned later)

# Component nodes
var model: Node3D
var animator: AnimationPlayer
var movement_controller: Node

# Personality and behavior
var personality_profile: PersonalityProfile
var current_behavior: String = "idle"
var current_state: Dictionary = {}

func _ready() -> void:
	personality_profile = PersonalityProfile.new()
	_initialize_components()
	print("[CharacterBase] Initialized: %s (%s)" % [character_name, character_id])

func _initialize_components() -> void:
	## Find or create child components
	animator = get_node_or_null("AnimationPlayer")
	if not animator:
		animator = AnimationPlayer.new()
		animator.name = "AnimationPlayer"
		add_child(animator)
	
	model = get_node_or_null("Model")
	if not model and model_path:
		_load_model()

func _load_model() -> void:
	## Load GLB/GLTF model from path
	## Will be called when model_path is assigned
	if model_path.is_empty():
		return
	
	var loaded_model = load(model_path)
	if loaded_model:
		model = loaded_model.instantiate()
		model.name = "Model"
		add_child(model)
		print("[CharacterBase] Model loaded: %s" % model_path)

func set_behavior(behavior_name: String) -> void:
	## Change character behavior
	current_behavior = behavior_name
	print("[CharacterBase] %s behavior changed to: %s" % [character_name, behavior_name])

func get_personality_value(trait: String) -> float:
	## Get a specific personality trait value
	return personality_profile.get_trait(trait)

func set_personality_value(trait: String, value: float) -> void:
	## Set a specific personality trait value
	personality_profile.set_trait(trait, value)

func load_personality_data(data: Dictionary) -> void:
	## Load personality profile from data
	personality_profile.load_from_dict(data)

func _process(_delta: float) -> void:
	pass
