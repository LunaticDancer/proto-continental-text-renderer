extends Control

var last_font_id : int = 0

func _ready() -> void:
	$HBoxContainer/VBoxContainer/FontSelection.get_popup().id_pressed.connect(react_to_font_selection)

func react_to_font_selection(id: int):
	last_font_id = id

func _on_text_to_translate_text_changed() -> void:
	$HBoxContainer/ScrollContainer/TextureRect.queue_redraw()


func _on_font_selection_pressed() -> void:
	$HBoxContainer/ScrollContainer/TextureRect.queue_redraw()


func _on_characters_per_line_text_changed() -> void:
	$HBoxContainer/ScrollContainer/TextureRect.queue_redraw()


func _on_line_margin_text_changed() -> void:
	$HBoxContainer/ScrollContainer/TextureRect.queue_redraw()


func _on_color_picker_button_color_changed(_color: Color) -> void:
	$HBoxContainer/ScrollContainer/TextureRect.queue_redraw()


func _on_render_button_pressed() -> void:
	$HBoxContainer/ScrollContainer/TextureRect.render_to_file()
