local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurrencyService = require(script.Parent.CurrencyService)
local DataStore = require(script.Parent.DataStore)
local InventoryServer = require(script.Parent.InventoryServer)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local Types = require(ReplicatedStorage.Shared.Types)
local packets = require(ReplicatedStorage.Shared.network)
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
		qi = { state = newState, progress = {} }
		if QuestData[questId].requirements.collect then
			if not qi.progress.collect then
				qi.progress.collect = {}
			end
			for item, amount in QuestData[questId].requirements.collect :: { [string]: number } do
				qi.progress.collect[item] = 0
			end
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

	packets.UpdateQuest.sendTo({
		questId = questId,
		progress = qi.progress,
	}, player)
end

--public functions

function QuestService.StartNextQuest(player: Player, npcId: string): string?
	local npcConfig = NPCData[npcId]
	local profile = DataStore.profiles[player.UserId]
	local qiTable = profile.Data.QuestInfo

	for _, questId in ipairs(npcConfig.questLine) do
		local qi = qiTable[questId]
		local state = qi and qi.state or "not_started"
		if not qi then
			setQuestState(player, questId, "not_started")
			packets.UpdateQuest.sendTo({
				questId = questId,
				progress = profile.Data.QuestInfo[questId].progress,
			}, player)
			return questId
		elseif state == "not_started" then
			setQuestState(player, questId, "in_progress")
			return questId
		elseif state == "in_progress" or state == "ready_to_turn_in" then
			return questId
		elseif state == "completed" then
			continue
		end
	end

	return nil
end

function QuestService.OnItemCollected(player: Player, itemId: string, amount: number): ()
	local profile = DataStore.profiles[player.UserId]
	local qiTable = profile.Data.QuestInfo

	for questId, qi in pairs(qiTable) do
		if qi.state == "in_progress" then
			local def: Types.QuestDef = QuestData[questId]
			if def.requirements.collect and def.requirements.collect[itemId] then
				updateQuestProgress(player, questId, itemId, amount)

				local done = true
				for reqItem, reqAmt in pairs(def.requirements.collect) do
					if (qi.progress.collect[reqItem] or 0) < reqAmt then
						done = false
						break
					end
				end
				if done then
					setQuestState(player, questId, "ready_to_turn_in")
				end
			end
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

	packets.CompleteQuest.sendTo(questId, player)
end

function QuestService.PlayerJoined(player: Player)
	local profile = DataStore.profiles[player.UserId]
	local qi = profile.Data.QuestInfo

	print(qi)

	if qi then
		packets.InitQuests.sendTo(qi, player)
	end
end

--public getters

function QuestService.GetPlayerQuestState(player: Player, questId: string)
	local qi = getQuestInfo(player, questId)
	return qi and qi.state or "not_started"
end

return QuestService
