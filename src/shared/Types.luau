-- type definitions
-- Usage: local Types = require(ReplicatedStorage.Shared.Types)

export type QuestState = "not_started" | "in_progress" | "ready_to_turn_in" | "completed"

export type QuestObjective = {
	type: "collect",
	id: string,
	amount: number,
} | {
	type: "mine",
	id: string,
	amount: number,
} | {
	type: "defeat",
	id: string,
	amount: number,
} | {
	type: "place",
	id: string,
	amount: number,
}

export type QuestDef = {
	id: string,
	name: string,
	npc: string,

	objectives: { QuestObjective }, -- new unified objective system

	rewards: {
		currency: number?,
		items: { { id: string, amount: number } }?,
	},
	dialogue: {
		not_started: { { text: string } },
		in_progress: { { text: string } },
		ready_to_turn_in: { { text: string } },
	},
}

export type QuestInfo = {
	state: QuestState,
	progress: { collect: { [string]: number }? }, -- itemId -> collected count
}

export type NPCConfig = {
	id: string,
	name: string,
	idleDialogue: { { text: string } },
	shopId: string?,
	questLine: { string },
	questDialogue: {
		[string]: {
			not_started: { { text: string } },
			in_progress: { { text: string } },
			ready_to_turn_in: { { text: string } },
		},
	},
}

export type ItemSlot = {
	count: number,
	itemInfo: {
		id: string,
	},
}

export type ProfileData = {
	Inventory: { ItemSlot },
	Currency: number,
	Blocks: { any },
	QuestInfo: { [string]: QuestInfo },
}

export type Profile = {
	Data: ProfileData,
}

return {}
