extends TextureRect

@export var fonts : Array[CompressedTexture2D]
@export var font_sizes : Array[Vector2i]

var character_limit : int = 20
var margin : int = 4
var color : Color = Color.DARK_GRAY
var font_id : int = 0
var font_image : Image
var char_size : Vector2i

func render_to_file():
	if $"../../VBoxContainer/HBoxContainer2/TextEdit".text == "":
		return
	
	texture.get_image().save_png(
		$"../../VBoxContainer/HBoxContainer2/TextEdit".text + ".png"
	)

func _draw() -> void:
	# data gathering
	character_limit = $"../../VBoxContainer/HBoxContainer/CharactersPerLine".text.to_int()
	margin = $"../../VBoxContainer/HBoxContainer3/LineMargin".text.to_int()
	color = $"../../VBoxContainer/HBoxContainer4/ColorPickerButton".color
	font_id = $"../../..".last_font_id
	font_image= Image.load_from_file(fonts[font_id].resource_path)
	char_size = font_sizes[font_id]
	var words : PackedStringArray = $"../../VBoxContainer/TextToTranslate".text.to_lower().split(" ", false, 0)
	var lines : Array[Line] = []
	lines.append(Line.new())
	
	# word translation
	for i in words.size():
		var word : Word = convert_word(words[i])
		if lines[-1].get_len() + word.get_len() > character_limit:
			lines.append(Line.new())
		lines[-1].Words.append(word)
	
	# rendering
	var w : int = lines.size() * char_size.x + (lines.size()-1) * margin
	var h : int = character_limit * char_size.y
	var img : Image = Image.create_empty(w, h, false, Image.FORMAT_RGBA8)
	
	for li in lines.size():
		var symbol_count : int = 0
		for word in lines[li].Words:
			for s in word.Syllables:
				draw_symbol(s.Consonant, li, symbol_count, img)
				draw_symbol(s.Vowel1, li, symbol_count, img)
				draw_symbol(s.Vowel2, li, symbol_count, img)
				symbol_count += 1
			draw_symbol(" ", li, symbol_count, img)
			symbol_count += 1
	
	texture = ImageTexture.create_from_image(img)
	draw_texture(texture, Vector2.ZERO, color)

func draw_symbol(_char : String, line : int, pos : int, target : Image):
	var char_id : int = CharLookup.get_char_index(_char)
	@warning_ignore("integer_division")
	var x : int = char_id / CharLookup.row_size
	var y : int = char_id % CharLookup.row_size
	var rect : Rect2i = Rect2i(Vector2i(x * char_size.x, y * char_size.y), char_size)
	target.blit_rect_mask(font_image, font_image, rect, 
		Vector2i(line * (char_size.x + margin), pos * char_size.y))

func convert_word(w : String):
	var result = Word.new()
	result.Syllables.append(Syllable.new())
	var letters : PackedStringArray = w.split("", false)
	
	for l in letters:
		if is_vowel(l):
			if result.Syllables[-1].Vowel1 == "":
				result.Syllables[-1].Vowel1 = l
			elif result.Syllables[-1].Vowel2 == "":
				result.Syllables[-1].Vowel2 = l.to_upper()
			else:
				result.Syllables.append(Syllable.new())
				result.Syllables[-1].Vowel1 = l
		else:		# not vowel
			if l == "'":
				result.Syllables.append(Syllable.new())
			elif result.Syllables[-1].Vowel1 != "":
				result.Syllables.append(Syllable.new())
				result.Syllables[-1].Consonant = l
			elif result.Syllables[-1].Consonant != "$":
				result.Syllables.append(Syllable.new())
				result.Syllables[-1].Consonant = l
			else:
				result.Syllables[-1].Consonant = l
	
	return result

func is_vowel(letter : String):
	match letter:
		"a":
			return true
		"o":
			return true
		"e":
			return true
		"u":
			return true
		"i":
			return true
	return false

class Line:
	var Words : Array[Word] = []
	
	func get_len():
		var result : int = 0
		for w in Words:
			result += w.get_len() + 1
		return result

class Word:
	var Syllables : Array[Syllable] = []
	
	func get_len():
		return Syllables.size()

class Syllable:
	var Consonant : String = "$"
	var Vowel1 : String = ""
	var Vowel2 : String = ""
