extends Node

const SAVE = 'user://data1.wf'
const PASS = '僕は君の事が好きだけど君は僕を別に好きじゃないみたい'
var F = File.new()
var unlocked = [1]
var high_scores = {1:0, 2:0, 3:0, 4:0}
var current_level = 0

func _ready():
	load_data()

func load_data():
	if F.file_exists(SAVE):
		if F.open_encrypted_with_pass(SAVE, File.READ, PASS) == OK:
			var data = F.get_var()
			unlocked = data.unlocked
			high_scores = data.high_scores
			F.close()
		else:
			Directory.new().remove(SAVE)
			save_data()
	else:
		save_data()

func save_data():
	if F.open_encrypted_with_pass(SAVE, File.WRITE, PASS) == OK:
		F.store_var({'unlocked': unlocked, 'high_scores': high_scores})
		F.close()

func unlock_next():
	if current_level < 4 and not current_level+1 in unlocked:
		unlocked.append(current_level+1)
		save_data()

func update_highscore(score):
	if score > high_scores[current_level]:
		high_scores[current_level] = score
		save_data()
