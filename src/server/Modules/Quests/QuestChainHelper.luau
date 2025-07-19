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

--[[
step 1: collect all quests tied to given npc
step 2: identify root quests, so not nextQuest of another
step 3: for each questline, walk until current step
step 4: ensure in_progress quests are always last so DialogueServer works
]]
function QuestChainHelper.GetAvailableQuests(player: Player, npcId: string)
	local profile = DataStore.profiles[player.UserId]
	local questInfo = profile.Data.QuestInfo
	local availableQuests = {}

	local npcQuests = {}

	--step 1
	for questId, questDef in pairs(QuestData) do
		if questDef.npc == npcId then
			table.insert(npcQuests, questId)
		end
	end

	--step 2
	local isNext = {}
	for _, questId in pairs(npcQuests) do
		local nextId = QuestData[questId].nextQuest
		if nextId then
			isNext[nextId] = true
		end
	end

	local rootQuests = {}
	for _, questId in pairs(npcQuests) do
		if not isNext[questId] then
			table.insert(rootQuests, questId)
		end
	end

	--step 3
	for _, rootId in pairs(rootQuests) do
		local currentQuestId = rootId

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
	end

	--step 4
	table.sort(availableQuests, function(a, b)
		if a.state == b.state then
			return false
		elseif a.state == "in_progress" then
			return false
		elseif b.state == "in_progress" then
			return true
		else
			return false
		end
	end)

	return availableQuests
end

return QuestChainHelper
