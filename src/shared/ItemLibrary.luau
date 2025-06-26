local ItemLibrary = {}

ItemLibrary.itemDefinitions = {
	["nothing"] = {
		type = "nothing",
		id = "nothing",
		maxStack = nil,
	},
	["dirt"] = {
		type = "block",
		id = "dirt",
		maxStack = 64,
	},
	["grass"] = {
		type = "block",
		id = "grass",
		maxStack = 64,
	},
	["stone"] = {
		type = "block",
		id = "stone",
		maxStack = 64,
	},
	["sand"] = {
		type = "block",
		id = "sand",
		maxStack = 64,
	},
	["log"] = {
		type = "block",
		id = "log",
		maxStack = 64,
	},
}

return ItemLibrary
