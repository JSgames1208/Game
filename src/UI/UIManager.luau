local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local Hotbar = require(StarterGui.UI.Frames.Hotbar)
local InventoryFrame = require(StarterGui.UI.Frames.InventoryFrame)
local NotificationFrame = require(StarterGui.UI.Frames.NotificationFrame)
local QuestFrame = require(StarterGui.UI.Frames.QuestFrame)
local NotificationService = require(StarterPlayer.StarterPlayerScripts.Client.Services.NotificationService)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local UIManager = {}

function UIManager.Init(scope)
	local notifications = scope:Value({})
	NotificationService.Init(scope, notifications)
	scope:New("ScreenGui")({
		Name = "MainGui",
		IgnoreGuiInset = false,
		ResetOnSpawn = false,
		[Children] = {
			Hotbar(scope),
			InventoryFrame(scope),
			QuestFrame(scope),
			NotificationFrame(scope, notifications),
		},
		Parent = Players.LocalPlayer.PlayerGui,
	})
	scope:New("ScreenGui")({
		Name = "DialogueGui",
		IgnoreGuiInset = false,
		ResetOnSpawn = false,
		Parent = Players.LocalPlayer.PlayerGui,
	})
end

return UIManager
