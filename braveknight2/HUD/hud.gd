extends CanvasLayer

@onready var Hp_label_ref = $MarginContainer/HpLabel
@onready var Live_label_ref = $MarginContainer/LivesLabel

func _ready():
	SignalManager.on_health_update.connect(update_health_label)
	SignalManager.on_lives_update.connect(update_Live_label)
	update_health_label(GameManager.hp)
	update_Live_label(GameManager.lives)

func update_health_label(hp: int):
	Hp_label_ref.text = "Hp: " + str(hp)

func update_Live_label(lives: int):
	Live_label_ref.text = "Vidas: " + str(lives)
