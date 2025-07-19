local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStore = require(ServerScriptService.Server.Services.DataStore)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local QuestChainHelper = {}

function QuestChainHelper.GetFirstQuestForNPC(npcName: string)
	local npcQuests = {}
	for id, quest in pairs(QuestData) do
		if quest.npc == npcName then
			npcQuests[id] = quest
		end
	end

	local nextQuests = {}
	for _, quest in pairs(npcQuests) do
		if quest.nextQuest then
			nextQuests[quest.nextQuest] = true
		end
	end

	for id, quest in pairs(npcQuests) do
		if not nextQuests[id] then
			return id
		end
	end

	return nil
end

function QuestChainHelper.GetAvailableQuests(player: Player, npcId: string)
	local npcName = npcId
	local profile = DataStore.profiles[player.UserId]
	local questInfo = profile.Data.QuestInfo
	local availableQuests = {}

	local currentQuestId = QuestChainHelper.GetFirstQuestForNPC(npcName)
	while currentQuestId do
		local state = questInfo[currentQuestId] and questInfo[currentQuestId].state or "not_started"
		if state == "not_started" or state == "ready_to_turn_in" then
			table.insert(availableQuests, { questId = currentQuestId, state = state })
			break
		elseif state == "in_progress" then
			table.insert(availableQuests, { questId = currentQuestId, state = state })
			break
		elseif state == "completed" then
			local questDef = QuestData[currentQuestId]
			currentQuestId = questDef.nextQuest
		else
			break
		end
	end

	return availableQuests
end

return QuestChainHelper
