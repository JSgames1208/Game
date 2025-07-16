-- type definitions
-- Usage: local Types = require(ReplicatedStorage.Shared.Types)

export type QuestState = "not_started" | "in_progress" | "ready_to_turn_in" | "completed"

export type QuestDef = {
	id: string,
	name: string,
	startDialogue: string,
	progressDialogue: string,
	completeDialogue: string,
	requirements: {
		collect: { [string]: number }?, -- itemId -> amount
	},
	rewards: {
		currency: number?,
		items: { { id: string, amount: number } }?,
	},
}

export type QuestInfo = {
	state: QuestState,
	progress: { collect: { [string]: number }? }, -- itemId -> collected count
}

export type NPCConfig = {
	id: string,
	name: string,
	idleDialogue: string,
	shopId: string?,
	questLine: { string },
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
