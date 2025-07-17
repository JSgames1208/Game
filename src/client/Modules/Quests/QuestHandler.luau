local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestUI = require(script.Parent.QuestUI)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local Types = require(ReplicatedStorage.Shared.Types)
local packets = require(ReplicatedStorage.Shared.network)

local questProgress = {}

--[[
QuestHandler.luau:
  - Receives updates from server
  - Checks which quests to update
  - Fires QuestUI function to change bars
]]

local QuestHandler = {}

function QuestHandler.UpdateQuest(
	questId,
	state: Types.QuestState,
	progress: { collect: { [string]: number }?, mine: { [string]: number } }
)
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

	if state == "ready_to_turn_in" then
		QuestUI.UpdateQuest(questId, progress)
		QuestUI.Ready(questId)
		return
	end

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

	if progress.mine and reqs.mine then
		for itemName, count in progress.mine do
			if count >= reqs.mine[itemName] then
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
		local questId, state, progress = data.questId, data.state, data.progress
		if questId and progress then
			QuestHandler.UpdateQuest(questId, state, progress)
		end
	end)

	packets.InitQuests.listen(function(data)
		for questId, quest in data do
			if quest.state ~= "completed" then
				QuestHandler.UpdateQuest(questId, quest.state, quest.progress)
			end
		end
	end)

	packets.CompleteQuest.listen(function(questId)
		questProgress[questId] = nil
		QuestUI.CompleteQuest(questId)
	end)
end

return QuestHandler
