local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packets = require(ReplicatedStorage.Shared.network)
local DialogueUI = require(script.Parent.DialogueUI)

local currentDialogue = nil
local currentStep = 0

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
	if not currentDialogue then
		return
	end

	currentStep += 1

	if currentStep <= #currentDialogue.text then
		DialogueUI.SetText(currentDialogue.text[currentStep].text)
	else
		if currentDialogue.options then
			DialogueUI.SetText("")
			DialogueUI.ShowOptions(currentDialogue.options, function(selectedOption)
				packets.ChooseDialogueOption.send({
					callback = selectedOption.callback,
					text = selectedOption.text,
					shopId = selectedOption.shopId or nil,
				})
			end)
		else
			DialogueUI.SetVisible(false)
		end
	end
end

function DialogueHandler.PlayDialogue(data)
	DialogueUI.SetText("")
	DialogueUI.SetNPCName("")
	DialogueUI.ShowOptions({}, function() end)

	currentDialogue = data
	currentStep = 1

	if data.text and #data.text > 0 then
		DialogueUI.SetText(data.text[currentStep].text)
	else
		DialogueUI.SetText("...")
	end

	DialogueUI.SetNPCName(data.npcId)
	DialogueUI.SetVisible(true)
end

packets.ShowDialogue.listen(function(data)
	DialogueHandler.PlayDialogue(data)
end)

packets.CloseDialogue.listen(function(data)
	DialogueUI.SetVisible(false)
end)

return DialogueHandler
