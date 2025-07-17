local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)
local NPCData: { [string]: Types.NPCConfig } = {
	Builder = {
		name = "Builder",
		id = "Builder",
		questLine = {
			"builder_1",
			"builder_2",
			"builder_3",
		},
		idleDialogue = "Hi there!",
		shopId = "Shop",
	},
	Farmer = {
		name = "Farmer",
		id = "Farmer",
		questLine = {
			"farmer_1",
			"farmer_2",
			"farmer_3",
		},
		idleDialogue = "Hi there!",
	},
}

return NPCData
