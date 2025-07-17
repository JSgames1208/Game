local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local NotificationService = require(StarterPlayer.StarterPlayerScripts.Client.Services.NotificationService)
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

function QuestHandler.UpdateQuest(questId, state: Types.QuestState, progress: { { amount: number } })
	if state == "completed" or (questProgress[questId] and questProgress[questId].state == "ready_to_turn_in") then
		return
	end

	local quest = QuestData[questId]
	if not quest then
		return
	end

	local objectives = quest.objectives
	if not objectives then
		return
	end

	local questComplete = true

	if not questProgress[questId] then
		questProgress[questId] = {}
	end
	questProgress[questId].progress = progress
	questProgress[questId].state = state

	for i, objective in ipairs(objectives) do
		local progressEntry = progress[i]
		if not progressEntry or progressEntry.amount < objective.amount then
			questComplete = false
			break
		end
	end

	QuestUI.UpdateQuest(questId, state, progress)

	if questComplete then
		questProgress[questId].state = "ready_to_turn_in"
		QuestUI.Ready(questId)
		NotificationService.AddNotification(`Quest complete: {QuestData[questId].name}`)
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
