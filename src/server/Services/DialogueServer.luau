local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local OptionHandler = require(ServerScriptService.Server.Modules.Dialogue.OptionHandler)
local QuestChainHelper = require(ServerScriptService.Server.Modules.Quests.QuestChainHelper)
local QuestService = require(ServerScriptService.Server.Services.QuestService)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local Types = require(ReplicatedStorage.Shared.Types)
local packets = require(ReplicatedStorage.Shared.network)
local DialogueService = {}

function DialogueService.Init()
	packets.StartDialogue.listen(function(data, player)
		if data.npcId then
			DialogueService.StartDialogue(player, data.npcId)
		end
	end)

	OptionHandler.Init()
end

local function getOptions(npcId)
	local opts = {}
	local npc = NPCData[npcId]
	if npc.shopId then
		table.insert(opts, { text = "Open Shop", callback = "openShop", shopId = npc.shopId })
	end
	table.insert(opts, { text = "Goodbye", callback = "endDialogue" })
	return opts
end

function DialogueService.StartDialogue(player: Player, npcId: string)
	local npc: Types.NPCConfig = NPCData[npcId]
	local availableQuests = QuestChainHelper.GetAvailableQuests(player, npcId)
	local quest = availableQuests[1]

	if not quest then
		packets.ShowDialogue.sendTo({
			text = npc.idleDialogue,
			npcId = npc.id,
			options = getOptions(npcId),
		}, player)
		return
	end

	local questId, state = quest.questId, quest.state
	local dialogueLines = QuestData[questId].dialogue[state] or { { text = "..." } }

	if state == "ready_to_turn_in" then
		QuestService.CompleteQuest(player, questId)
	elseif state == "not_started" then
		QuestService.SetQuestState(player, questId, "in_progress")
	end

	packets.ShowDialogue.sendTo({
		text = dialogueLines,
		npcId = npc.id,
		options = getOptions(npcId),
	}, player)
end

return DialogueService
