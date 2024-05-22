extends AnimatedSprite2D

@onready var xpSprite = self

func _process(delta):
	xpSprite.frame = GameManager.player_xp
