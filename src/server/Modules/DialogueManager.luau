local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestManager = require(script.Parent.QuestManager)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local packets = require(ReplicatedStorage.Shared.network)
local DialogueManager = {}

local function getOptions(npcId)
	local opts = {}
	local npc = NPCData[npcId]
	if npc.shopId then
		table.insert(opts, { text = "Open Shop", callback = "openShop", shopId = npc.shopId })
	end
	table.insert(opts, { text = "Goodbye", callback = "endDialogue" })
	return opts
end

function DialogueManager.StartDialogue(player: Player, npcId: string)
	local npc: NPCData.NPCConfig = NPCData[npcId]
	local nextQuestId: string? = QuestManager.StartNextQuest(player, npcId)
	local state = nextQuestId and QuestManager.GetPlayerQuestState(player, nextQuestId) or nil

	print(npc, nextQuestId, state)

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

			QuestManager.CompleteQuest(player, nextQuestId)

			packets.ShowDialogue.sendTo({
				text = "",
				options = getOptions(npcId),
			}, player)
		elseif nextQuestId and state == "not_started" then
			packets.ShowDialogue.sendTo({
				text = QuestData[nextQuestId].startDialogue,
			}, player)

			QuestManager.StartNextQuest(player, npcId)

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
		DialogueManager.StartDialogue(player, data.npcId)
	end
end)

return DialogueManager
