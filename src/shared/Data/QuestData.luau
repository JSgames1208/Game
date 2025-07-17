local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

local QuestData: { [string]: Types.QuestDef } = {
	quest1 = {
		id = "quest1",
		name = "Collect Materials 1",
		startDialogue = "Bring back 10 grass please.",
		progressDialogue = "Still waiting on my materials",
		completeDialogue = "quest completed!",
		requirements = {
			collect = { grass = 5 },
		},
		rewards = {
			currency = 100,
			items = { { id = "sand", amount = 5 } },
		},
	},
	quest2 = {
		id = "quest2",
		name = "Collect Materials 2",
		startDialogue = "Bring back 20 grass please.",
		progressDialogue = "Still waiting on my materials",
		completeDialogue = "joepieeee!",
		requirements = {
			collect = { sand = 5 },
		},
		rewards = {
			currency = 100,
			items = { { id = "stone", amount = 64 } },
		},
	},
	quest3 = {
		id = "quest2",
		name = "Collect Materials 3",
		startDialogue = "Bring back 20 grass please.",
		progressDialogue = "Still waiting on my materials",
		completeDialogue = "cool!",
		requirements = {
			collect = { stone = 5 },
		},
		rewards = {
			currency = 100,
			items = { { id = "log", amount = 64 } },
		},
	},
	quest4 = {
		id = "quest4",
		name = "Break blocks 1",
		startDialogue = "Break 5 grass",
		progressDialogue = "Still waiting...",
		completeDialogue = "cool!",
		requirements = {
			mine = { grass = 5 },
		},
		rewards = {
			currency = 100,
			items = { { id = "golden_pickaxe", amount = 1 } },
		},
	},
}

return QuestData
