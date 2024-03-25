
# TODO 1
# 0. Escape button  should pause game and take user back to menu (probably need to allow user mapping this button  as well)
# 1. Resume -> should continue game where the user left it (if he clicked escape previously).
# 2. Surbi death processing (show death screen plus restart,  go back to menu or quit)

# TODO 2
# 1. Arcade logic on test map:
# 1.1 Multiple spawn points
# 2.2 Introduce zombie waves, each wave will be started manually by player by shooting 
# 	Like: "shoot to attrack the horde"
# 2.3 Introduce score counter (based on time, damage taken and kills)
# 2.4 Each wave should should trigger differnt music (maybe 10th wave would be a Payback song?)
# 2.5 Arcade HUD - the wave number on screen, player score + how many enemies are left to defeat
# 2.5 Waves should scale up to 10 wave, after that difficulty stays the same
# 2.6 I would raise difficulty by adding more zombies and nudging their stats up till the threshold.
# 2.7 Make cactus hurt player
# 2.8 Maybe better collision shapes for players and  enemies? I wonder if polygons would do the trick.

# TODO 3
# -1. Find out about loading screens and how to do it in optimized way (to not preload everything to RAM)
# 0. Find and fix all TODO's in code.
# 1. better enemy pathfinding + new arcade level (non  test) -> this would corelate with a better map design
#	possible idea: add new pathfinding as an algorithm which can  be picked, but leave my previous for dumber zombies. 
# 	I would probably need to create some assets I can just put on map with a colision polygon on them
# 	This way I wouldn't have to do it over and over for each map. I could just place lets say cactus and 
# 	enemies will collide.

# TODO  4: improvements
# 0. Resolution scaling (I  want for the player to  be able to pick a resolution)
# 1. Nicer menu 
# 1.1 Less pixels
# 1.2 Some interesting background as well
# 1.3 Sounds on clicking on the main menu (not on options since that would be just annoying)
# 2. Sound design - currently it is uneveen and a bit  quiet.
# 2.1 Sound volume normalization (i  want same level of audio for all of my samples)
# 2.2 More custome made songs for my game ( find or create so i  can swap my  first choices)
# 3. More enemy types.
# 4. Player HUD improvements:
# 4.1 HUD for bullets (how many are in cylinder)
# 4.2 Better health HUD?
# 5. Graphics improvement (maybe less pixelated? and fix animation?)
# 6. Level design improvements?
# 7. Totems logic? -  the idea is that Surbi would find item, which would on right click do something (like for example teleport  or second revolver)
# 8. Shit-talking dialogue lines for Surbi, when he performes good (score is high)
# 9. Multiplayer (local PC hosting a server for the other who knows the ID and password)
# 10. Start release process to see how difficult it is.

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
