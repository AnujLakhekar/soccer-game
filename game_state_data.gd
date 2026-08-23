class_name GameStateData
extends Node

var scored_country = ""


static func build() -> GameStateData:
	return GameStateData.new()

func set_scored_country(country : String) -> GameStateData:
	scored_country = country
	return self
