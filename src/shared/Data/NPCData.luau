local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)
local NPCData: { [string]: Types.NPCConfig } = {
	NPC = {
		name = "NPC",
		id = "NPC",
		questLine = {
			"quest1",
			"quest2",
			"quest3",
		},
		idleDialogue = "Hi there!",
		shopId = "Shop",
	},
}

return NPCData
