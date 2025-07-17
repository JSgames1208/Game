local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Quest = require(StarterGui.UI.Features.Quests.Quest)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local scope = Fusion.scoped(Fusion)

local MainGui = PlayerGui:WaitForChild("MainGui")
local QuestFrame = MainGui:WaitForChild("QuestFrame")
local ScrollingFrame = QuestFrame:WaitForChild("ScrollingFrame")

local questProgress = {}
local quests = {}

local QuestUI = {}

function QuestUI.Init() end

function QuestUI.StartQuest() end

function QuestUI.UpdateQuest(questId: string, state: string, progress: { { amount: number } })
	if questProgress[questId] then
		for i, progressObj in ipairs(progress) do
			if scope.peek(questProgress[questId][i]) ~= progressObj.amount then
				questProgress[questId][i]:set(progressObj.amount)
			end
		end
	else
		questProgress[questId] = {}

		for i, progressObj in ipairs(progress) do
			questProgress[questId][i] = scope:Value(progressObj.amount)
		end

		local completeSignal = scope:Value(state == "ready_to_turn_in")
		local questUI = Quest(scope, questProgress[questId], completeSignal, questId)

		questUI.Parent = ScrollingFrame
		quests[questId] = {
			instance = questUI,
			complete = completeSignal,
		}
	end
end

function QuestUI.Ready(questId)
	if quests[questId] then
		quests[questId].complete:set(true)
	end
end

function QuestUI.CompleteQuest(questId: string)
	questProgress[questId] = nil
	if quests[questId] then
		quests[questId].instance:Destroy()
		quests[questId] = nil
	end
end

return QuestUI
