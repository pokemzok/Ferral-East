extends Node2D

# TODO 1
# 2. Basic sound design:
#	2.1 Pick If I should use AudioStreamPlayer or AudioStreamPlayer2D
#   2.2 Zombie hurt sound  (like bullet penetrating skin)
#	2.3 Surbi hurt sound
# 2. better enemy pathfinding + arcade level design -> this would corelate with a better map design
#	possible idea:  leave default zombies without changes but introduce new enemy with new  path-finding behaviour.


# TODO 2
# 1. Arcade login on test map: dynamically add enemies in some sort of a wave logic. 
# 2. I might show the wave number on screen and how many enemies are left to defeat

# I would probably need to create some assets I can just put on map with a colision polygon on them
# This way I wouldn't have to do it over and over for each map. I could just place lets say cactus and 
# enemies will collide.


# At the beginning lets just make them  spawn correctly and do correct spawn number
# then I might implement generating enemies with randomized stats which will increase in difficulty
# next: some nice level  design
# last some score calculation logic (based on time, damage taken and kills).
# HUD for bullets (how many are in cylinder)
# shit-talking dialogue lines for Surbi, when he performes good.
# sound volume normalization (i  want same level of audio for all of my samples)
# find/ create decent sounds and music for the game (so i can swap my first choices)
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
