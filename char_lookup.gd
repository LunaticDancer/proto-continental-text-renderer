extends Node

const row_size : int = 12

# $ means empty consonant spot
const ref : Array[String] = [
	" ", "$", "a", "A", "o", "O", "e", "E", "i", "I", "u", "U",
	"b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p",
	"q", "r", "s", "t", "v", "x", "z", "0", "1", "2", "3", "4",
	"5", "6", "7", ".", ",", "?", "!",
]

func get_char_index(_char : String) -> int:
	var index : int = ref.find(_char)
	if(_char == "w"):
		index = 28
	if(_char == "y"):
		index = 8
	if(_char == "Y"):
		index = 9
	if index == -1:
		return 0
	return index
