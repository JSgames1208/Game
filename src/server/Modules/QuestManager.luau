local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurrencyManager = require(script.Parent.CurrencyManager)
local DataStore = require(script.Parent.DataStore)
local InventoryManager = require(script.Parent.InventoryManager)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local Types = require(ReplicatedStorage.Shared.Types)
local QuestManager = {}

--private functions

local function getQuestInfo(player: Player, questId: string): { any }
	local profile = DataStore.profiles[player.UserId]
	return profile.Data.QuestInfo[questId]
end

local function setQuestState(player: Player, questId: string, newState: Types.QuestState): ()
	local profile = DataStore.profiles[player.UserId]
	local qi = profile.Data.QuestInfo[questId]
	print(qi)
	if not qi then
		qi = { state = newState, progress = {} }
		print(qi)
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
	if qi.progress[itemId] then
		qi.progress[itemId] += amount
	else
		qi.progress[itemId] = amount
	end
end

--public functions

function QuestManager.StartNextQuest(player: Player, npcId: string): string?
	local npcConfig = NPCData[npcId]
	local profile = DataStore.profiles[player.UserId]
	local qiTable = profile.Data.QuestInfo

	for _, questId in ipairs(npcConfig.questLine) do
		local qi = qiTable[questId]
		local state = qi and qi.state or "not_started"
		if not qi then
			setQuestState(player, questId, "not_started")
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

function QuestManager.OnItemCollected(player: Player, itemId: string, amount: number): ()
	local profile = DataStore.profiles[player.UserId]
	local qiTable = profile.Data.QuestInfo

	for questId, qi in pairs(qiTable) do
		if qi.state == "in_progress" then
			local def: Types.QuestDef = QuestData[questId]
			if def.requirements.collect and def.requirements.collect[itemId] then
				updateQuestProgress(player, questId, itemId, amount)

				local done = true
				for reqItem, reqAmt in pairs(def.requirements.collect) do
					if (qi.progress[reqItem] or 0) < reqAmt then
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

function QuestManager.CompleteQuest(player: Player, questId: string): ()
	local profile = DataStore.profiles[player.UserId]
	local qi = profile.Data.QuestInfo[questId]
	if not (qi and qi.state == "ready_to_turn_in") then
		return
	end

	qi.state = "completed"
	local def = QuestData[questId]

	if def.rewards.currency then
		CurrencyManager.AddCurrency(player, def.rewards.currency)
	end

	if def.rewards.items then
		for _, item in pairs(def.rewards.items) do
			InventoryManager.GiveItem(player, item.id, item.amount)
		end
	end
end

--public getters

function QuestManager.GetPlayerQuestState(player: Player, questId: string)
	local qi = getQuestInfo(player, questId)
	return qi and qi.state or "not_started"
end

return QuestManager
