local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local AutoScaledFrame = require(StarterGui.UI.Components.AutoScaledFrame)
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local ImageIds = require(StarterGui.UI.ImageIds)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local function QuestMenu(scope: typeof(Fusion.scoped(Fusion)))
	--[[local s = scope:innerScope({
		TextLabel = TextLabel,
	})

	return scope:New("Frame")({
		Name = "QuestMenu",
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Color3.fromRGB(83, 83, 83),
		Size = UDim2.new(0.2, 0, 1, 0),
		[Children] = {
			scope:New("UIListLayout")({
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			scope:New("UISizeConstraint")({
				MinSize = Vector2.new(150, 600),
			}),
			scope:New("TextLabel")({
				Name = "QuestLabel",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 100, 0, 40),
				FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold),
				Text = "Quests",
				TextScaled = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
			}),
			scope:New("ScrollingFrame")({
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0.95, 0),
				ClipsDescendants = true,
				[Children] = {
					scope:New("UIListLayout")({}),
				},
			}),
		},
	})]]

	local s = scope:innerScope({
		AutoScaledFrame = AutoScaledFrame,
		TextLabel = TextLabel,
	})

	local frame = s:AutoScaledFrame({
		Size = UDim2.fromOffset(720, 1763),
		Position = UDim2.fromOffset(24, 24),
	})

	local Image = scope:New("ImageLabel")({
		Size = UDim2.fromScale(1, 1),
		Image = ImageIds["QuestFrame"],
		BackgroundTransparency = 1,
	})

	Image.Parent = frame

	local QuestLabel = s:TextLabel({
		Name = "QuestLabel",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0.0627, 0),
		FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold),
		Text = "Quests",
		TextScaled = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextStroke = { Thickness = 5, Color = Color3.fromRGB(0, 0, 0), Transparency = 0 },
		ZIndex = 10,
	})

	QuestLabel.Parent = frame

	return frame
end
return QuestMenu
