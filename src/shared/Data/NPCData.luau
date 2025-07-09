export type NPCConfig = {
	questLine: { string }, -- quest ids
	idleDialogue: string,
	shopId: string?,
}

local NPCData: { [string]: NPCConfig } = {
	NPC = {
		questLine = {
			"quest1",
			"quest2",
		},
		idleDialogue = "Hi there!",
		shopId = "Shop",
	},
}

return NPCData
