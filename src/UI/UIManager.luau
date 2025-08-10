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

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local function _checkInit(guiName: string): boolean
	return PlayerGui:FindFirstChild(guiName) and true or false
end

function UIManager.Init(scope)
	local notifications = scope:Value({})
	NotificationService.Init(scope, notifications)
	if not _checkInit("MainGui") then
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
	end
	if not _checkInit("DialogueGui") then
		scope:New("ScreenGui")({
			Name = "DialogueGui",
			IgnoreGuiInset = false,
			ResetOnSpawn = false,
			Parent = Players.LocalPlayer.PlayerGui,
		})
	end
	if not _checkInit("ShopGui") then
		scope:New("ScreenGui")({
			Name = "ShopGui",
			IgnoreGuiInset = false,
			ResetOnSpawn = false,
			Parent = Players.LocalPlayer.PlayerGui,
		})
	end
end

return UIManager
