local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Hotbar = require(StarterGui.UI.Frames.Hotbar)
local InventoryFrame = require(StarterGui.UI.Frames.InventoryFrame)
local QuestFrame = require(StarterGui.UI.Frames.QuestFrame)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local UIManager = {}

function UIManager.Init(scope)
	scope:New("ScreenGui")({
		Name = "MainGui",
		IgnoreGuiInset = false,
		ResetOnSpawn = false,
		[Children] = {
			Hotbar(scope),
			InventoryFrame(scope),
			QuestFrame(scope),
		},
		Parent = Players.LocalPlayer.PlayerGui,
	})
end

return UIManager
