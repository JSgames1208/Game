local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local QuestService = require(ServerScriptService.Server.Services.QuestService)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
local Types = require(ReplicatedStorage.Shared.Types)
local packets = require(ReplicatedStorage.Shared.network)
local DialogueService = {}

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
	local nextQuestId: string? = QuestService.StartNextQuest(player, npcId)
	local state = nextQuestId and QuestService.GetPlayerQuestState(player, nextQuestId) or nil

	print(npc, nextQuestId, state)

	print(nextQuestId, state)

	if nextQuestId then
		if state == "in_progress" then
			packets.ShowDialogue.sendTo({
				text = npc.questLine[nextQuestId].in_progress,
				npcId = npc.id,
				options = getOptions(npcId),
			}, player)
		elseif state == "ready_to_turn_in" then
			packets.ShowDialogue.sendTo({
				text = npc.questLine[nextQuestId].ready_to_turn_in,
				npcId = npc.id,
				options = getOptions(npcId),
			}, player)

			QuestService.CompleteQuest(player, nextQuestId)
		elseif nextQuestId and state == "not_started" then
			print({ text = npc.questLine[nextQuestId].not_started })
			packets.ShowDialogue.sendTo({
				text = npc.questLine[nextQuestId].not_started,
				npcId = npc.id,
				options = getOptions(npcId),
			}, player)

			QuestService.StartNextQuest(player, npcId)
		else
			packets.ShowDialogue.sendTo({
				text = npc.idleDialogue,
				npcId = npc.id,
				options = getOptions(npcId),
			}, player)
		end
	else
		packets.ShowDialogue.sendTo({
			text = npc.idleDialogue,
			npcId = npc.id,
			options = getOptions(npcId),
		}, player)
	end
end

packets.ChooseDialogueOption.listen(function(data, player)
	if data.callback == "openShop" then
		packets.OpenShop:sendTo({ shopId = data.shopId }, player)
	elseif data.callback == "endDialogue" then
		packets.CloseDialogue:sendTo(nil, player)
	end
end)

packets.StartDialogue.listen(function(data, player)
	if data.npcId then
		DialogueService.StartDialogue(player, data.npcId)
	end
end)

return DialogueService
