export type Requirement = {
	collect: { [string]: number },
}

export type Reward = {
	currency: number?,
	items: { { id: string, amount: number } }?,
}

export type QuestDef = {
	id: string,
	name: string,
	startDialogue: string,
	progressDialogue: string,
	completeDialogue: string,
	requirements: Requirement,
	rewards: Reward,
}

export type QuestState = "not_started" | "in_progress" | "ready_to_turn_in" | "completed"

export type QuestInfo = {
	state: QuestState,
	progress: { any },
}

local QuestData: { [string]: QuestDef } = {
	quest1 = {
		id = "quest1",
		name = "Gather Materials",
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
		name = "Gather Materials",
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
