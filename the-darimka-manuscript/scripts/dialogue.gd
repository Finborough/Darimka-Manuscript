extends Control

@export var dialogue_resource: DialogueResource
@onready var input_field: LineEdit = $LineEdit 

# The maximum number of typos allowed (1 or 2 is usually best)
const MAX_TYPO_DISTANCE: int = 1

func open_menu() -> void:
	show()
	PauseManager.register_menu(self)

func close_menu() -> void:
	hide()
	PauseManager.unregister_menu(self)

func _on_line_edit_text_submitted(submitted_text: String) -> void:
	# 1. Clean punctuation and split into individual lowercase words
	var regex = RegEx.new()
	regex.compile("[^a-zA-Z0-9\\s]") 
	var cleaned_text = regex.sub(submitted_text, "", true).to_lower()
	var words = cleaned_text.split(" ", false)
	
	if words.is_empty():
		input_field.text = ""
		return

	var target_title: String = "unknown"
	
	# 2. Check each word the user typed against your dialogue titles
	for word in words:
		# First: Check for an exact match (fastest)
		if dialogue_resource.titles.has(word):
			target_title = word
			break
		
		# Second: Check for close misspellings if no exact match is found
		var closest_match: String = ""
		var lowest_distance: int = MAX_TYPO_DISTANCE + 1
		
		for title in dialogue_resource.titles:
			var title_lower = title.to_lower()
			var distance = get_levenshtein_distance(word, title_lower)
			
			if distance < lowest_distance:
				lowest_distance = distance
				closest_match = title

		if lowest_distance <= MAX_TYPO_DISTANCE:
			target_title = closest_match
			break

	# 3. Reset input
	input_field.text = ""

	# 4. Show dialogue
	DialogueManager.show_dialogue_balloon(dialogue_resource, target_title)


# Helper function to calculate typo distance
func get_levenshtein_distance(s: String, t: String) -> int:
	if s == t: return 0
	if s.length() == 0: return t.length()
	if t.length() == 0: return s.length()
	
	var v0: Array[int] = []
	var v1: Array[int] = []
	v0.resize(t.length() + 1)
	v1.resize(t.length() + 1)
	
	for i in range(v0.size()):
		v0[i] = i
		
	for i in range(s.length()):
		v1[0] = i + 1
		for j in range(t.length()):
			var cost = 0 if s[i] == t[j] else 1
			v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost))
		for j in range(v0.size()):
			v0[j] = v1[j]
			
	return v1[t.length()]
