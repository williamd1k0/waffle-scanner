extends Node2D


func goal_reached():
	$AnimationPlayer.play('goal-reached')
	$Goal/Sfx.play()

func update_goal(val):
	$Goal/GoalText.text = str(val)

func update_waffles(val):
	$Waffles/WafflesText.text = str(val)

func update_rate(val):
	$ProdSpeed/RateText.text = str(val)
