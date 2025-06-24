extends CanvasLayer

@onready var Hp_label_ref = $MarginContainer/HpLabel

func _ready():
	SignalManager.on_health_update.connect(update_health_label)

func update_health_label(hp: int):
	Hp_label_ref.text = "Vida: " + str(hp)
