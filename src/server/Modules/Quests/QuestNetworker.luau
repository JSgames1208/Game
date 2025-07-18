local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)

local QuestNetworker = {}

function QuestNetworker.UpdateQuest(player: Player, questId: string, state, progress)
	print(questId, state, progress)
	packets.UpdateQuest.sendTo({
		questId = questId,
		state = state,
		progress = progress,
	}, player)
end

function QuestNetworker.InitPlayer(player: Player, questInfo)
	packets.InitQuests.sendTo(questInfo, player)
end

function QuestNetworker.CompleteQuest(player: Player, questId: string)
	packets.CompleteQuest.sendTo(questId, player)
end

function QuestNetworker.UpdateQuestMarker(player: Player, npcName: string, show: boolean)
	print(npcName, show)
	packets.UpdateQuestMarker.sendTo({ npcName = npcName, show = show }, player)
end

return QuestNetworker
