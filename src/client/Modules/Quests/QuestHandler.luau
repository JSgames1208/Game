local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestUI = require(script.Parent.QuestUI)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local packets = require(ReplicatedStorage.Shared.network)

local questProgress = {}

--[[
QuestHandler.luau:
  - Receives updates from server
  - Checks which quests to update
  - Fires QuestUI function to change bars
]]

local QuestHandler = {}

function QuestHandler.UpdateQuest(questId, progress: { collect: { [string]: number }? })
	local quest = QuestData[questId]
	if not quest then
		return
	end

	local reqs = quest.requirements
	if not reqs then
		return
	end

	local questComplete = true

	questProgress[questId] = progress

	if progress.collect and reqs.collect then
		for itemName, count in progress.collect do
			if count >= reqs.collect[itemName] then
				continue
			else
				questComplete = false
				continue
			end
		end

		QuestUI.UpdateQuest(questId, progress)
	end
end

function QuestHandler.Init()
	packets.UpdateQuest.listen(function(data)
		local questId, progress = data.questId, data.progress
		if questId and progress then
			QuestHandler.UpdateQuest(questId, progress)
		end
	end)

	packets.InitQuests.listen(function(data)
		for questId, quest in data do
			print("HEre")
			if quest.state ~= "completed" then
				print("Not here")
				QuestHandler.UpdateQuest(questId, quest.progress)
			end
		end
	end)

	packets.CompleteQuest.listen(function(questId)
		questProgress[questId] = nil
		QuestUI.CompleteQuest(questId)
	end)
end

return QuestHandler
