# TODO 2
# 0. Fix incorrect events processing bug in surival mode.
# 1. Drop item on enemy death.
#		I can keep all the rewards (like second revolver or regen), while having a bit more randomness.
#		I can also introduce items, which would increase a chance of getting specific rewards.
#		I can also pass wave info to enemies to slightly increase drop chances later on?  
#		Like Health Update might be a pentagram visible on the zombie. Zombie will have all possible items + drop chance.   
# 1.4 If player reaches 13 bullets in chamber (on 13 bullet), player will unlock second revolver with a 12 bullets (would need to create an asset for that).
# 1.5 If player reach 10 HP (on 10th HP) then player gain regen. After each wave gain +1HP (if HP is missing).
# 1.6 If player reach max speed  (7 level),  maybe player will unlock bullet-time (like a slow motion for a few seconds + power bar, which will regen on player killing enemies).
# 2. Revisit increasing of the difficulty level after those changes and try to nudge it into the right direction.
# 3. New test level which would allow pathfinding. 
# 4. New zombie enemy (different color) which would be smarter (will use pathfinding) and would be reanimating once with less HP.
# 5. Maybe a miniboss as well, basically same guy as Surbi, but more HP 
# 6. Score should take into consideration time it took player to complete wave. Wave counts as started after player completed leveling up.

# TODO 1
# 1. Find a way to prevent animation from looping on death (zombie does not need looping when they die, or Surbi) 
# 2. limit fire rate (maybe this would help for reload glitch)
# 3. Make whistle sound (end of the wave) louder and shorter.
# 4. Make cactus hurt player and enemy

# TODO  3: improvements
# 0. Resolution scaling (I  want for the player to  be able to pick a resolution)
# 1. Nicer menu and loading screens
# 1.1 Some interesting background as well
# 1.2 Sounds on clicking on the main menu (not on options since that would be just annoying)
# 2. Sound design
# 2.1 Sound volume normalization (i  want same level of audio for all of my samples)
# 2.2 More custome made songs for my game ( find or create so i  can swap my  first choices)
# 3. More enemy types.
# 6. Level design improvements?
# 7. Totems logic? -  the idea is that Surbi would find item, which would on right click do something (like for example teleport  or second revolver). Player can switch between second power using scroll or num pad.
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
