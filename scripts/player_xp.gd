extends AnimatedSprite2D

@onready var xpSprite = self

func _process(delta):
	xpSprite.frame = GameManager.player_xp
	
	if GameManager.is_player_special:
		get_parent().visible = false
	else:
		get_parent().visible = true
