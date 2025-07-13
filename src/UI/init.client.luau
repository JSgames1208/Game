local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AutoScaledFrame = require(script.Components.AutoScaledFrame)
local Hotbar = require(script.Frames.Hotbar)
local InventoryFrame = require(script.Frames.InventoryFrame)
local QuestMenu = require(script.Frames.QuestMenu)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

scoped = Fusion.scoped

local scope = scoped(Fusion, {
	Hotbar = Hotbar,
	InventoryFrame = InventoryFrame,
	QuestMenu = QuestMenu,
	AutoScaledFrame = AutoScaledFrame,
})

--[[local colorSequence: ColorSequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 115, 0)),
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 238, 0)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(17, 255, 0)),
	ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 204, 255)),
	ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 4, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(247, 0, 255)),
})]]

--[[
scope:New("ScreenGui")({
	Parent = PlayerGui,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	[Children] = {
		scope:TextLabel({
			Name = "Test",
			Text = "Test",
			Size = UDim2.new(0.2, 0, 0.1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(150, 150, 150),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			CornerRadius = UDim.new(0, 8),
			BackgroundColorRotation = -20,
			TextColorRotation = 0,
			ZIndex = 1,
			Stroke = {
				Thickness = 5,
				Color = Color3.fromRGB(255, 255, 255),
				Transparency = 0,
				ColorRotation = 20,
			},
			TextStroke = {
				Thickness = 3,
				Color = colorSequence,
				Transparency = 0,
				ColorRotation = 0,
			},
		} :: TextLabel.TextLabelProps),
	},
})
]]

--[[scope:New("ScreenGui")({
	Parent = PlayerGui,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	[Children] = {
		scope:Button({
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.2, 0, 0.1, 0),
			ImageId = "rbxassetid://134471285632211",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Stroke = { Thickness = 5, Color = colorSequence, ColorRotation = 20, Transparency = 0 },
		} :: Button.ButtonProps),
	},
})]]

scope:New("ScreenGui")({
	Name = "InventoryGui",
	Parent = PlayerGui,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	[Children] = {
		scope:Hotbar(),
		scope:InventoryFrame(),
	},
})

scope:New("ScreenGui")({
	Name = "QuestGui",
	Parent = PlayerGui,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	[Children] = {
		scope:QuestMenu(),
	},
})
