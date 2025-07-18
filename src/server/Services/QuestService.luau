local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ObjectiveHandler = require(ServerScriptService.Server.Modules.Quests.ObjectiveHandler)
local QuestMarkerServer = require(ServerScriptService.Server.Modules.Quests.QuestMarkerServer)
local QuestNetworker = require(ServerScriptService.Server.Modules.Quests.QuestNetworker)
local CurrencyService = require(script.Parent.CurrencyService)
local DataStore = require(script.Parent.DataStore)
local InventoryServer = require(script.Parent.InventoryServer)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local Types = require(ReplicatedStorage.Shared.Types)
local QuestService = {}

--private functions

local function getQuestInfo(player: Player, questId: string): { any }
	local profile = DataStore.profiles[player.UserId]
	return profile.Data.QuestInfo[questId]
end

local function setQuestState(player: Player, questId: string, newState: Types.QuestState): ()
	local profile = DataStore.profiles[player.UserId]
	local qi = profile.Data.QuestInfo[questId]

	if not qi then
		qi = {
			state = newState,
			progress = {},
		}

		local questDef = QuestData[questId]
		for i, objective in ipairs(questDef.objectives or {}) do
			qi.progress[i] = { amount = 0 }
		end

		profile.Data.QuestInfo[questId] = qi
	else
		qi.state = newState
	end
end

local function updateQuestProgress(player: Player, questId: string, itemId: string, amount: number): ()
	local profile = DataStore.profiles[player.UserId]
	local qi = profile.Data.QuestInfo[questId]
	if not qi then
		return
	end
	if not qi.progress.collect then
		qi.progress.collect = {}
	end
	if qi.progress.collect[itemId] then
		qi.progress.collect[itemId] += amount
	else
		qi.progress.collect[itemId] = amount
	end

	QuestNetworker.UpdateQuest(player, questId, qi.state, qi.progress)
end

--public functions

function QuestService.StartNextQuest(player: Player, npcId: string): string?
	local npcConfig = NPCData[npcId]
	local profile = DataStore.profiles[player.UserId]
	local qiTable = profile.Data.QuestInfo

	print(qiTable)

	for _, questId in pairs(npcConfig.questLine) do
		local qi = qiTable[questId]
		local state = qi and qi.state or "not_started"
		if not qi then
			setQuestState(player, questId, "not_started")

			QuestNetworker.UpdateQuest(player, questId, "not_started", profile.Data.QuestInfo[questId].progress)
			return questId
		elseif state == "not_started" then
			setQuestState(player, questId, "in_progress")
			QuestMarkerServer.Update(player, profile.Data.QuestInfo, questId)
			return questId
		elseif state == "in_progress" or state == "ready_to_turn_in" then
			return questId
		elseif state == "completed" then
			continue
		end
	end

	return nil
end

function QuestService.IsQuestComplete(questDef, progress)
	for i, objective in ipairs(questDef.objectives or {}) do
		if progress[i] and (progress[i].amount or 0) < objective.amount then
			return false
		end
	end
	return true
end

function QuestService.HandleEvent(player: Player, event: Types.QuestObjective)
	local profile = DataStore.profiles[player.UserId]
	local questInfo = profile.Data.QuestInfo

	for questId, qi in pairs(questInfo) do
		if qi.state == "completed" then
			continue
		end
		local def = QuestData[questId]

		for i, objective in ipairs(def.objectives or {}) do
			local progress = qi.progress[i] or { amount = 0 }
			qi.progress[i] = progress

			local handler = ObjectiveHandler[objective.type]
			if handler and handler(objective, event) then
				progress.amount = math.min(progress.amount + (event.amount or 1), objective.amount)
			end
		end

		QuestNetworker.UpdateQuest(player, questId, qi.state, qi.progress)
		QuestMarkerServer.Update(player, questInfo, questId)

		if QuestService.IsQuestComplete(def, qi.progress) then
			setQuestState(player, questId, "ready_to_turn_in")
			QuestNetworker.UpdateQuest(player, questId, "ready_to_turn_in", qi.progress)
			QuestMarkerServer.Ready(player, questId)
		end
	end
end

function QuestService.CompleteQuest(player: Player, questId: string): ()
	local profile = DataStore.profiles[player.UserId]
	local qi = profile.Data.QuestInfo[questId]
	if not (qi and qi.state == "ready_to_turn_in") then
		return
	end

	qi.state = "completed"
	local def = QuestData[questId]

	if def.rewards.currency then
		CurrencyService.AddCurrency(player, def.rewards.currency)
	end

	if def.rewards.items then
		for _, item in pairs(def.rewards.items) do
			InventoryServer.GiveItem(player, item.id, item.amount)
		end
	end

	QuestNetworker.CompleteQuest(player, questId)
	QuestMarkerServer.Update(player, profile.Data.QuestInfo, questId)
end

function QuestService.PlayerJoined(player: Player)
	local profile = DataStore.profiles[player.UserId]
	local qi = profile.Data.QuestInfo

	if qi then
		QuestNetworker.InitPlayer(player, qi)
		QuestMarkerServer.PlayerJoined(player, qi)
	end
end

--public getters

function QuestService.GetPlayerQuestState(player: Player, questId: string)
	local qi = getQuestInfo(player, questId)
	return qi and qi.state or "not_started"
end

return QuestService
