extends CanvasLayer

@onready var timer_label: Label = $LabelTimer
@onready var point_label: Label = $LabelPoints
@onready var ammo_label: Label = $LabelAmmo

func _ready():
	pass
	
func _process(delta: float):
	timer_label.text = GameManager.time_elapsed_string
	point_label.text = str(GameManager.enemies_defeated)
	ammo_label.text = str(GameManager.ammo) + "/" + str(GameManager.max_ammo)
