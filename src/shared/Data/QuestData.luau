local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

local QuestData: { [string]: Types.QuestDef } = {
	farmer_1 = {
		id = "farmer_1",
		name = "Farmer: Quest 1",
		startDialogue = "Mine 1 pine tree!",
		progressDialogue = "Still waiting...",
		completeDialogue = "Quest complete!",
		objectives = {
			{ type = "mine", id = "pine tree", amount = 1 },
		},
		rewards = {
			currency = 50,
			items = { { id = "pine tree sapling", amount = 2 } },
		},
	},
	farmer_2 = {
		id = "farmer_2",
		name = "Farmer: Quest 2",
		startDialogue = "Plant 3 pine tree saplings!",
		progressDialogue = "Still waiting...",
		completeDialogue = "Quest complete!",
		objectives = {
			{ type = "place", id = "pine tree sapling", amount = 3 },
		},
		rewards = {
			currency = 100,
			items = { { id = "pine tree sapling", amount = 10 }, { id = "log", amount = 20 } },
		},
	},
	farmer_3 = {
		id = "farmer_3",
		name = "Farmer: Quest 3",
		startDialogue = "Plant and mine 20 pine trees!",
		progressDialogue = "Still waiting...",
		completeDialogue = "Quest complete!",
		objectives = {
			{ type = "place", id = "pine tree sapling", amount = 20 },
			{ type = "mine", id = "pine tree", amount = 20 },
		},
		rewards = {
			currency = 200,
			items = { { id = "log", amount = 64 }, { id = "diamond_pickaxe", amount = 1 } },
		},
	},
	builder_1 = {
		id = "builder_1",
		name = "Builder: Quest 1",
		startDialogue = "Place 5 grass blocks!",
		progressDialogue = "Still waiting...",
		completeDialogue = "Quest complete!",
		objectives = {
			{ type = "place", id = "grass", amount = 5 },
		},
		rewards = {
			currency = 50,
			items = { { id = "stone", amount = 20 } },
		},
	},
	builder_2 = {
		id = "builder_2",
		name = "Builder: Quest 2",
		startDialogue = "Place 20 stone!",
		progressDialogue = "Still waiting...",
		completeDialogue = "Quest complete!",
		objectives = {
			{ type = "place", id = "stone", amount = 20 },
		},
		rewards = {
			currency = 100,
			items = { { id = "sand", amount = 20 } },
		},
	},
	builder_3 = {
		id = "builder_3",
		name = "Builder: Quest 3",
		startDialogue = "Place 20 sand and plant 8 pine saplings!",
		progressDialogue = "Still waiting...",
		completeDialogue = "Quest complete!",
		objectives = {
			{ type = "place", id = "sand", amount = 20 },
			{ type = "place", id = "pine tree sapling", amount = 8 },
		},
		rewards = {
			currency = 200,
			items = { { id = "obsidian pickaxe", amount = 1 } },
		},
	},
}

return QuestData
