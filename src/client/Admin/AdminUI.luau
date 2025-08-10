local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local AppBar = require(StarterGui.UI.Frames.AppBar)
local AdminUI = {}

local scope = Fusion.scoped(Fusion)

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local AdminGui = nil

function AdminUI.Init()
	if not AdminGui then
		AdminGui = scope:New("ScreenGui")({
			Name = "AdminGui",
			IgnoreGuiInset = false,
			ResetOnSpawn = false,
			Parent = PlayerGui,
		})
		local appBar = AppBar(scope)
		appBar.Parent = AdminGui
	end
end

return AdminUI
