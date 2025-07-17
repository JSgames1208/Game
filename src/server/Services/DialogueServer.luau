local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local QuestService = require(ServerScriptService.Server.Services.QuestService)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
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
				text = QuestData[nextQuestId].progressDialogue,
				options = getOptions(npcId),
			}, player)
		elseif state == "ready_to_turn_in" then
			packets.ShowDialogue.sendTo({
				text = QuestData[nextQuestId].completeDialogue,
			}, player)

			QuestService.CompleteQuest(player, nextQuestId)

			packets.ShowDialogue.sendTo({
				text = "",
				options = getOptions(npcId),
			}, player)
		elseif nextQuestId and state == "not_started" then
			packets.ShowDialogue.sendTo({
				text = QuestData[nextQuestId].startDialogue,
			}, player)

			QuestService.StartNextQuest(player, npcId)

			packets.ShowDialogue.sendTo({
				text = "",
				options = getOptions(npcId),
			}, player)
		else
			packets.ShowDialogue.sendTo({
				text = npc.idleDialogue,
				options = getOptions(npcId),
			}, player)
		end
	else
		packets.ShowDialogue.sendTo({
			text = npc.idleDialogue,
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
