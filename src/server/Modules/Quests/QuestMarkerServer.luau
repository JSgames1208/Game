local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local QuestChainHelper = require(script.Parent.QuestChainHelper)
local NPCFromQuest = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Quests.NPCFromQuest)
local QuestNetworker = require(script.Parent.QuestNetworker)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)

--[[
QuestMarkerServer.luau:
--When player joins, check which npc's have unclaimed quests, if so send an event per npc
--When a player completes a quest, check if the npc has another quest, if so send an event per npc
]]

local QuestMarkerServer = {}

local function CheckShow(player: Player, npcId: string)
	local availableQuests = QuestChainHelper.GetAvailableQuests(player, npcId)

	for _, quest in availableQuests do
		if quest.state ~= "in_progress" then
			return true
		end
	end

	return false
end

function QuestMarkerServer.PlayerJoined(player: Player, questInfo)
	for _, npcConfig in pairs(NPCData) do
		local show = CheckShow(player, npcConfig.id)
		QuestNetworker.UpdateQuestMarker(player, npcConfig.name, show)
	end
end

function QuestMarkerServer.Ready(player: Player, questId: string)
	local npcName = QuestData[questId] and QuestData[questId].npc

	if not npcName then
		warn(`Quest {questId} has no NPC assigned.`)
		return
	end

	QuestNetworker.UpdateQuestMarker(player, npcName, true)
end

function QuestMarkerServer.Update(player: Player, questInfo, questId: string)
	local quest = QuestData[questId]
	if not quest then
		warn(`Quest not found: {questId}`)
		return
	end

	local npcName = quest.npc
	local npcConfig = NPCData[npcName]
	if not npcConfig then
		warn(`NPCData not found for NPC: {npcName}`)
		return
	end

	local show = CheckShow(player, npcName)

	QuestNetworker.UpdateQuestMarker(player, npcName, show)
end

return QuestMarkerServer
