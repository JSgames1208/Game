local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local NPCFromQuest = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Quests.NPCFromQuest)
local QuestNetworker = require(script.Parent.QuestNetworker)
local NPCData = require(ReplicatedStorage.Shared.Data.NPCData)

--[[
QuestMarkerServer.luau:
--When player joins, check which npc's have unclaimed quests, if so send an event per npc
--When a player completes a quest, check if the npc has another quest, if so send an event per npc
]]

local QuestMarkerServer = {}

local function CheckShow(NPC, questInfo)
	print(questInfo)
	if not NPC.questLine then
		return false
	end

	local playerQuestStates = {}
	for questId, qi in pairs(questInfo) do
		playerQuestStates[questId] = qi.state
	end

	for _, questId in pairs(NPC.questLine) do
		local state = playerQuestStates[questId]

		print(questId, state)

		if state == "completed" then
			continue -- quest is done, move to next in line
		elseif state == "ready_to_turn_in" then
			return true -- ready to turn in, show marker
		elseif state == "in_progress" then
			return false -- already working on it, don’t show marker
		else
			-- Quest not started yet, so it's the next one
			return true
		end
	end

	-- All quests completed, no marker needed
	return false
end

function QuestMarkerServer.PlayerJoined(player: Player, questInfo)
	for _, NPC in NPCData do
		local show = CheckShow(NPC, questInfo)
		QuestNetworker.UpdateQuestMarker(player, NPC.name, show)
	end
end

function QuestMarkerServer.Ready(player: Player, questId: string)
	local NPC = NPCFromQuest(questId)

	if not NPC then
		warn(`NPC not found: {NPC}`)
		return
	end

	QuestNetworker.UpdateQuestMarker(player, NPC, true)
end

function QuestMarkerServer.Update(player: Player, questInfo, questId: string)
	local NPC = NPCFromQuest(questId)

	if not NPC then
		warn(`NPC not found: {NPC}`)
		return
	end

	local NPCData = NPCData[NPC]
	if not NPCData then
		warn(`NPCData not found for NPC: {NPC}`)
		return
	end

	local show = CheckShow(NPCData, questInfo)

	QuestNetworker.UpdateQuestMarker(player, NPC, show)
end

return QuestMarkerServer
