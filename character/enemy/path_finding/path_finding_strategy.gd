class_name PathFindingStrategy
extends Node

enum PathFindingAlgorithm {
	DUMB_COLLIDE,
	NAVIGATION_AGENT
}

static var algorithms = [PathFindingAlgorithm.DUMB_COLLIDE, PathFindingAlgorithm.NAVIGATION_AGENT]

static func random_strategy() -> PathFindingAlgorithm:
	return algorithms[randi() % algorithms.size()] 
