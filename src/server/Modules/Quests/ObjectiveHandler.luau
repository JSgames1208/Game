local ObjectiveHandler = {}

ObjectiveHandler["collect"] = function(objective, event)
	print(objective, event)
	return event.type == "collect" and event.id == objective.id
end

ObjectiveHandler["place"] = function(objective, event)
	return event.type == "place" and event.id == objective.id
end

ObjectiveHandler["mine"] = function(objective, event)
	return event.type == "mine" and event.id == objective.id
end

ObjectiveHandler["defeat"] = function(objective, event)
	return event.type == "defeat" and event.id == objective.id
end

return ObjectiveHandler
