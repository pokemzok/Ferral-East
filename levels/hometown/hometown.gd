extends Node2D

# TODO 1
# 1. reload after 6 shots
# 2. better enemy pathfinding

# TODO 2
# 1. Arcade login on test map: dynamically add enemies in some sort of a wave logic. 
# 2. I might show the wave number on screen and how many enemies are left to defeat

# I would probably need to create some assets I can just put on map with a colision polygon on them
# This way I wouldn't have to do it over and over for each map. I could just place lets say cactus and 
# enemies will collide.


# At the beginning lets just make them  spawn correctly and do correct spawn number
# then I might implement generating enemies with randomized stats which will increase in difficulty
# next I might want some hud for showing my  characters Health points
# next: some nice level  design
# last some score calculation logic (based on time, damage taken and kills).
# after all that I can try to release this game somewhere to see how difficult it is.

# For future
# Halina is a melee (higher damage, more health, ability to regenerate between waves)
# Aneta is faster runner but slower gunner

# Potential powers:
	# Surbi otrzymuje drugi rewolwer i większą prędkość  strzelania
	# Aneta wpada w  panikę, więc biega jeszcze szybciej a  jej strzały zadają więcej obrażeń.
	# Halina dostaje  większe klapki i god mode na  kilka sekund i zabija wszystkich na hita

# Potenial enemy behaviours:
	# Fake death, some zombie will  get up after a while
	# necromancer apprentice - can  reanimate fallen zombie, which are still spawned on the ground
