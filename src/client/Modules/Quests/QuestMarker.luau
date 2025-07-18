local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local QuestMarkerUI = require(StarterGui.UI.Features.Quests.QuestMarkerUI)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local packets = require(ReplicatedStorage.Shared.network)
local NPCFromQuest = require(script.Parent.NPCFromQuest)
local NPCFolder = workspace:WaitForChild("NPCs")

local scope = Fusion.scoped(Fusion)

local npcEnabled = {}

local QuestMarker = {}

--[[
QuestMarker.luau:
--Instantiate markers for all npcs
--Show marker when quest is ready
--Show marker when npc has an unclaimed quest ready
]]

function QuestMarker.Init()
	for _, NPC in NPCFolder:GetChildren() do
		local enabled = scope:Value(false)
		npcEnabled[NPC.Name] = enabled
		local marker = QuestMarkerUI(scope, enabled)
		marker.Parent = NPC
	end

	packets.UpdateQuestMarker.listen(function(data)
		if data.npcName and data.show ~= nil then
			QuestMarker.Update(data.npcName, data.show)
		end
	end)
end

function QuestMarker.Update(npcName: string, show: boolean)
	print(npcName, show)
	local NPC = NPCFolder:FindFirstChild(npcName)

	if not NPC then
		warn(`NPC: {npcName} was not found!`)
		return
	end

	npcEnabled[npcName]:set(show)
end

return QuestMarker
