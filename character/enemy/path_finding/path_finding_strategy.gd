class_name PathFindingStrategy
extends Node

enum PathFindingAlgorithm {
	DUMB_COLLIDE,
	DUMB_SLIDE
}

static var algorithms = [PathFindingAlgorithm.DUMB_COLLIDE, PathFindingAlgorithm.DUMB_SLIDE]

static func random_strategy() -> PathFindingAlgorithm:
	return algorithms[0]
	#return algorithms[randi() % algorithms.size()] FIXME, uncomment when I have better strategies
