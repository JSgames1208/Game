local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local DialogueFrame = require(StarterGui.UI.Frames.DialogueFrame)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local packets = require(ReplicatedStorage.Shared.network)

local DialogueUI = {}

local scope = Fusion.scoped(Fusion)
local visible = scope:Value(false)
local npcName = scope:Value("")
local text = scope:Value("")
local options = scope:Value({})

local optionCallback = scope:Value(function() end)

local clickCallback

local isHovering = nil

local function MouseEnter()
	isHovering = true
end

local function MouseLeave()
	isHovering = false
end

function DialogueUI.SetClickCallback(callback)
	clickCallback = callback
end

function DialogueUI.Init()
	local DialogueFrame: Frame = DialogueFrame(
		scope,
		{ visible = visible, npcName = npcName, text = text, options = options },
		MouseEnter,
		MouseLeave,
		optionCallback
	)
	DialogueFrame.Parent = Players.LocalPlayer.PlayerGui:WaitForChild("DialogueGui")
end

function DialogueUI.SetVisible(boolean: boolean)
	visible:set(boolean)
end

function DialogueUI.SetNPCName(string: string)
	npcName:set(string)
end

function DialogueUI.SetText(string: string)
	text:set(string)
end

function DialogueUI.ShowOptions(table, callback)
	optionCallback:set(callback)
	options:set(table)
end

function DialogueUI.MouseButton1Click()
	if isHovering then
		clickCallback()
	end
end

return DialogueUI
