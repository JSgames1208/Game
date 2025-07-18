local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local DialogueFrame = require(StarterGui.UI.Frames.DialogueFrame)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local packets = require(ReplicatedStorage.Shared.network)

local DialogueUI = {}

local scope = Fusion.scoped(Fusion)
visible = scope:Value(false)
text = scope:Value("")
options = scope:Value({})

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
	local DialogueFrame: Frame =
		DialogueFrame(scope, { visible = visible, text = text, options = options }, MouseEnter, MouseLeave)
	DialogueFrame.Parent = Players.LocalPlayer.PlayerGui:WaitForChild("DialogueGui")
end

function DialogueUI.SetVisible(boolean: boolean)
	visible:set(boolean)
end

function DialogueUI.MouseButton1Click()
	if isHovering then
		clickCallback()
	end
end

return DialogueUI
