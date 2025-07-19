local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)
local NPCData: { [string]: Types.NPCConfig } = {
	Builder = {
		name = "Builder",
		id = "Builder",
		questLine = {
			["builder_1"] = {
				not_started = {
					{ text = "Yo, I've got a quest for you!" },
				},
				in_progress = {
					{ text = "How's the quest going?" },
				},
				ready_to_turn_in = {
					{ text = "Congrats on finishing my quest!" },
				},
			},
			["builder_2"] = {
				not_started = {
					{ text = "Yo, I've got a quest for you!" },
				},
				in_progress = {
					{ text = "How's the quest going?" },
				},
				ready_to_turn_in = {
					{ text = "Congrats on finishing my quest!" },
				},
			},
			["builder_3"] = {
				not_started = {
					{ text = "Yo, I've got a quest for you!" },
				},
				in_progress = {
					{ text = "How's the quest going?" },
				},
				ready_to_turn_in = {
					{ text = "Congrats on finishing my quest!" },
				},
			},
		},
		idleDialogue = { { text = "Hi there!" } },
		shopId = "Shop",
	},
	Farmer = {
		name = "Farmer",
		id = "Farmer",
		questLine = {
			["farmer_1"] = {
				not_started = {
					{ text = "Yo, I've got a quest for you!" },
					{ text = "Yo, imagine this works first try hahaa" },
				},
				in_progress = {
					{ text = "How's the quest going?" },
				},
				ready_to_turn_in = {
					{ text = "Congrats on finishing my quest!" },
				},
			},
			["farmer_2"] = {
				not_started = {
					{ text = "Yo, I've got a quest for you!" },
				},
				in_progress = {
					{ text = "How's the quest going?" },
				},
				ready_to_turn_in = {
					{ text = "Congrats on finishing my quest!" },
				},
			},
			["farmer_3"] = {
				not_started = {
					{ text = "Yo, I've got a quest for you!" },
				},
				in_progress = {
					{ text = "How's the quest going?" },
				},
				ready_to_turn_in = {
					{ text = "Congrats on finishing my quest!" },
				},
			},
		},
		idleDialogue = { { text = "Hi there!" } },
		optionDialogue = { { text = "What brings you here today?" } },
	},
}

return NPCData
