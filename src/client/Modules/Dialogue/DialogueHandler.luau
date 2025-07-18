local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packets = require(ReplicatedStorage.Shared.network)
local DialogueUI = require(script.Parent.DialogueUI)
local DialogueHandler = {}

--[[
DialogueHandler.luau:

--Receives inputs from InputManager
--MouseButton1Click -> next step

]]

function DialogueHandler.Init()
	DialogueUI.SetClickCallback(function()
		DialogueHandler.ProcessClick()
	end)
end

function DialogueHandler.ProcessClick()
	DialogueUI.SetVisible(false)
end

packets.ShowDialogue.listen(function(data)
	DialogueUI.SetVisible(true)
end)

return DialogueHandler
