extends Node

@onready var hud = get_tree().current_scene.get_node("HUD")
@onready var dialogue_ui = hud.get_node("DialogueUI")

func focus_line_edit(): 
	dialogue_ui.input_field.grab_focus()

func bye():
	dialogue_ui.close_menu()
