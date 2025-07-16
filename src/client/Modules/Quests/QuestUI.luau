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

function QuestUI.UpdateQuest(questId: string, progress: { collect: { [string]: number }? })
	print(questId, progress)
	if questProgress[questId] and questProgress[questId].collect and progress.collect then
		for itemId, amount in questProgress[questId].collect do
			if scope.peek(questProgress[questId].collect[itemId]) ~= progress.collect[itemId] then
				questProgress[questId].collect[itemId]:set(progress.collect[itemId])
				print(scope.peek(questProgress[questId].collect[itemId]))
			end
		end
	else
		--Make quest
		if QuestData[questId].requirements.collect ~= nil and progress.collect then
			for itemId, count in QuestData[questId].requirements.collect :: { [string]: number } do
				if not questProgress[questId] then
					questProgress[questId] = {}
				end
				if not questProgress[questId].collect then
					questProgress[questId].collect = {}
				end

				questProgress[questId].collect[itemId] = scope:Value(progress.collect[itemId])
			end
		end

		local quest = Quest(scope, questProgress[questId], questId)
		quest.Parent = ScrollingFrame
		quests[questId] = quest
	end
end

function QuestUI.Update() end

function QuestUI.CompleteQuest(questId: string)
	--Remove quest

	questProgress[questId] = nil
	if quests[questId] then
		quests[questId]:Destroy()
	end
	quests[questId] = nil
end

return QuestUI
