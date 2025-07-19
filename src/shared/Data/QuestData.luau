local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

local QuestData: { [string]: Types.QuestDef } = {
	farmer_1 = {
		id = "farmer_1",
		name = "Farmer: Quest 1",
		npc = "Farmer",

		objectives = {
			{ type = "mine", id = "pine tree", amount = 1 },
		},

		rewards = {
			currency = 50,
			items = { { id = "pine tree sapling", amount = 2 } },
		},

		dialogue = {
			not_started = { { text = "Plant 1 pine tree sapling" } },
			in_progress = { { text = "Still waiting..." } },
			ready_to_turn_in = { { text = "Quest complete!" } },
		},

		nextQuest = "farmer_2",
	},
	farmer_2 = {
		id = "farmer_2",
		name = "Farmer: Quest 2",
		npc = "Farmer",

		objectives = {
			{ type = "place", id = "pine tree sapling", amount = 3 },
		},
		rewards = {
			currency = 100,
			items = { { id = "pine tree sapling", amount = 10 }, { id = "log", amount = 20 } },
		},

		dialogue = {
			not_started = { { text = "Plant 3 pine tree saplings!" } },
			in_progress = { { text = "Still waiting..." } },
			ready_to_turn_in = { { text = "Quest complete!" } },
		},

		nextQuest = "farmer_3",
	},
	farmer_3 = {
		id = "farmer_3",
		name = "Farmer: Quest 3",
		npc = "Farmer",

		objectives = {
			{ type = "place", id = "pine tree sapling", amount = 5 },
			{ type = "mine", id = "pine tree", amount = 5 },
		},
		rewards = {
			currency = 200,
			items = { { id = "log", amount = 64 }, { id = "diamond pickaxe", amount = 1 } },
		},

		dialogue = {
			not_started = { { text = "Plant and mine 5 pine trees!" } },
			in_progress = { { text = "Still waiting..." } },
			ready_to_turn_in = { { text = "Quest complete!" } },
		},
	},
	builder_1 = {
		id = "builder_1",
		name = "Builder: Quest 1",
		npc = "Builder",

		objectives = {
			{ type = "place", id = "grass", amount = 5 },
		},
		rewards = {
			currency = 50,
			items = { { id = "stone", amount = 20 } },
		},

		dialogue = {
			not_started = { { text = "Place 5 grass blocks!" } },
			in_progress = { { text = "Still waiting..." } },
			ready_to_turn_in = { { text = "Quest complete!" } },
		},

		nextQuest = "builder_2",
	},
	builder_2 = {
		id = "builder_2",
		name = "Builder: Quest 2",
		npc = "Builder",

		objectives = {
			{ type = "place", id = "stone", amount = 20 },
		},
		rewards = {
			currency = 100,
			items = { { id = "sand", amount = 20 } },
		},

		dialogue = {
			not_started = { { text = "Place 5 stone!" } },
			in_progress = { { text = "Still waiting..." } },
			ready_to_turn_in = { { text = "Quest complete!" } },
		},

		nextQuest = "builder_3",
	},
	builder_3 = {
		id = "builder_3",
		name = "Builder: Quest 3",
		npc = "Builder",

		objectives = {
			{ type = "place", id = "sand", amount = 5 },
			{ type = "place", id = "pine tree sapling", amount = 5 },
		},
		rewards = {
			currency = 200,
			items = { { id = "obsidian pickaxe", amount = 1 } },
		},

		dialogue = {
			not_started = { { text = "Place 5 sand and plant 5 pine saplings!" } },
			in_progress = { { text = "Still waiting..." } },
			ready_to_turn_in = { { text = "Quest complete!" } },
		},
	},
	farmer_extra_1 = {
		id = "farmer_extra_1",
		name = "Farmer: Extra quest 1",
		npc = "Farmer",

		objectives = {
			{ type = "mine", id = "pine tree", amount = 1 },
		},

		rewards = {
			currency = 50,
			items = { { id = "sand", amount = 10 } },
		},

		dialogue = {
			not_started = { { text = "Plant 1 pine tree sapling" } },
			in_progress = { { text = "Still waiting..." } },
			ready_to_turn_in = { { text = "Quest complete!" } },
		},

		nextQuest = "farmer_extra_2",
	},
	farmer_extra_2 = {
		id = "farmer_extra_2",
		name = "Farmer: Extra quest 2",
		npc = "Farmer",

		objectives = {
			{ type = "mine", id = "pine tree", amount = 1 },
		},

		rewards = {
			currency = 50,
			items = { { id = "stone", amount = 10 } },
		},

		dialogue = {
			not_started = { { text = "Plant 1 pine tree sapling" } },
			in_progress = { { text = "Still waiting..." } },
			ready_to_turn_in = { { text = "Quest complete!" } },
		},
	},
}

return QuestData
