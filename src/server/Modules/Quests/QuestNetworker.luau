local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)

local QuestNetworker = {}

function QuestNetworker.UpdateQuest(player, questId, state, progress)
	print(questId, state, progress)
	packets.UpdateQuest.sendTo({
		questId = questId,
		state = state,
		progress = progress,
	}, player)
end

function QuestNetworker.InitPlayer(player, questInfo)
	packets.InitQuests.sendTo(questInfo, player)
end

function QuestNetworker.CompleteQuest(player, questId)
	packets.CompleteQuest.sendTo(questId, player)
end

return QuestNetworker
