class_name PathFindingStrategy
extends Node

enum PathFindingAlgorithm {
	DUMB_COLLIDE,
	DUMB_SLIDE
}

static var algorithms = [PathFindingAlgorithm.DUMB_COLLIDE, PathFindingAlgorithm.DUMB_SLIDE]

static func random_strategy() -> PathFindingAlgorithm:
	return algorithms[randi() % algorithms.size()]
