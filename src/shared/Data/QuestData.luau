local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

local QuestData: { [string]: Types.QuestDef } = {
	quest1 = {
		id = "quest1",
		name = "Gather Materials 1",
		startDialogue = "Bring back 10 grass please.",
		progressDialogue = "Still waiting on my materials",
		completeDialogue = "Good boyyyy!",
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
		name = "Gather Materials 2",
		startDialogue = "Bring back 20 grass please.",
		progressDialogue = "Still waiting on my materials",
		completeDialogue = "Good boyyyyyyyyyyyy!",
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
		name = "Gather Materials 3",
		startDialogue = "Bring back 20 grass please.",
		progressDialogue = "Still waiting on my materials",
		completeDialogue = "Good boyyyyyyyyyyyy!",
		requirements = {
			collect = { sand = 5 },
		},
		rewards = {
			currency = 100,
			items = { { id = "stone", amount = 64 } },
		},
	},
}

return QuestData
