local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local WindowManager = require(StarterGui.UI.Features.Admin.WindowManager)
local AppBarUI = require(script.Parent.AppBarUI)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local AppBar = require(StarterGui.UI.Frames.AppBar)
local AdminUI = {}

local visible: boolean = false

local scope = Fusion.scoped(Fusion)

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local AdminGui = nil
local WindowGui = nil

function AdminUI.Init()
	if not AdminGui then
		AdminGui = scope:New("ScreenGui")({
			Name = "AdminGui",
			IgnoreGuiInset = false,
			ResetOnSpawn = false,
			Parent = PlayerGui,
			Enabled = false,
		})

		local appBar = AppBar(scope)
		appBar.Parent = AdminGui

		WindowGui = WindowManager.Init(scope)
		AppBarUI.Init(scope)

		AppBarUI.Populate({ { name = "Test1" }, { name = "Test2" }, { name = "Test3" } })
	end
end

function AdminUI.Toggle()
	visible = not visible

	AdminGui.Enabled = visible
	WindowGui.Enabled = visible
end

return AdminUI
