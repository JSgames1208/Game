local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local DialogueFrame = require(StarterGui.UI.Frames.DialogueFrame)
local DialogueHandler = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Dialogue.DialogueHandler)
local DialogueUI = require(StarterPlayer.StarterPlayerScripts.Client.Modules.Dialogue.DialogueUI)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local packets = require(ReplicatedStorage.Shared.network)

local DialogueClient = {}

function DialogueClient.Start()
	for _, NPC in workspace.NPCs:GetChildren() do
		if NPC:FindFirstChild("InteractPrompt") then
			local prompt: ProximityPrompt = NPC.InteractPrompt
			prompt.Triggered:Connect(function()
				packets.StartDialogue.send({ npcId = NPC.Name })
			end)
		end
	end

	DialogueUI.Init()
	DialogueHandler.Init()
end

return DialogueClient
