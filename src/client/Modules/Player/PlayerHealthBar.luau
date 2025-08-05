local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HealthBar = require(StarterGui.UI.Frames.HealthBars.HealthBar)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local MainGui = PlayerGui:WaitForChild("MainGui")

local scope = Fusion.scoped(Fusion)

local currentHP = scope:Value(100)
local maxHP = scope:Value(100)

HealthBarManager = {}

function HealthBarManager.Init(_currentHP, _maxHP)
	currentHP:set(_currentHP)
	maxHP:set(_maxHP)

	local screenSize = scope:Value(workspace.CurrentCamera.ViewportSize)
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		screenSize:set(workspace.CurrentCamera.ViewportSize)
	end)

	local HealthBar = HealthBar(
		scope,
		{
			currentHP = currentHP,
			maxHP = maxHP,

			AnchorPoint = Vector2.new(0.5, 1),
			Size = UDim2.new(0.5, 0, 0.01, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Position = scope:Computed(function(use)
				return UDim2.new(0.5, 0, -0.0125, use(screenSize).Y - use(screenSize).X / 10.0)
			end),

			AddText = true,
		} :: HealthBar.HealthBarProps
	)

	HealthBar.Parent = MainGui
end

function HealthBarManager.SetCurrentHP(hp: number | "max")
	if hp == "max" then
		currentHP:set(scope.peek(maxHP))
		return
	end
	currentHP:set(hp)
end

function HealthBarManager.SetMaxHP(maxhp: number)
	maxHP:set(maxhp)
end

return HealthBarManager
