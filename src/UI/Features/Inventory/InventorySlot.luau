local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local UIStroke = require(StarterGui.UI.Components.UIStroke)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local function InventorySlot(scope: typeof(Fusion.scoped(Fusion)))
	local s = scope:innerScope({
		UIStroke = UIStroke,
		TextLabel = TextLabel,
	})

	return scope:New("Frame")({
		Name = "Frame",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 0.6,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		[Children] = {
			scope:New("ViewportFrame")({
				Name = "IconViewport",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0.9, 0, 0.9, 0),
			}),
			scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width,
			}),
			s:UIStroke({
				Enabled = false,
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 0.4,
				Thickness = 5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			} :: UIStroke.UIStrokeProps),
			scope:New("TextLabel")({
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Name = "Amount",
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(0.85, 0, 0.4, 0),
				Text = "",
				TextScaled = true,
				TextTransparency = 0.2,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold),
			}),
		},
	})
end

return InventorySlot
