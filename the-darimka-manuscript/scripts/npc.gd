extends CharacterBody2D

@export var dialogue_title: String = "start"
@export var dialogue_resource: DialogueResource
var balloon

func trigger_interaction() -> void:
	if dialogue_resource:
		print(dialogue_resource)
		balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_title)
		Global.dialogue_ui.dialogue_resource = dialogue_resource
	else:
		printerr("Dialogue Resource is missing on this node!")

func _process(delta: float) -> void:
	if is_near and Input.is_action_just_pressed("interact") and not get_tree().paused:
		
		
		trigger_interaction()
		Global.dialogue_ui.open_menu()
	if Input.is_action_just_pressed("ui_cancel"):
		Global.dialogue_ui.close_menu()
		if balloon:
			balloon.queue_free()

var is_near = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_near = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_near = false
