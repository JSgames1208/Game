local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local function UIDivision(scope: typeof(Fusion.scoped(Fusion)))
	return scope:New("Frame")({
		Name = "MainUILayout",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[Children] = {
			scope:New("Frame")({
				Name = "LeftPanel",
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1 / 5, 5 / 6),
				BackgroundColor3 = Color3.fromRGB(80, 80, 80),
				BorderSizePixel = 0,
			}),

			scope:New("Frame")({
				Name = "Center",
				Position = UDim2.fromScale(1 / 5, 0),
				Size = UDim2.fromScale(3 / 5, 5 / 6),
				BackgroundColor3 = Color3.fromRGB(120, 120, 120),
				BorderSizePixel = 0,
			}),

			scope:New("Frame")({
				Name = "RightPanel",
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(1 / 5, 5 / 6),
				BackgroundColor3 = Color3.fromRGB(80, 80, 80),
				BorderSizePixel = 0,
			}),

			scope:New("Frame")({
				Name = "BottomBar",
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.fromScale(1, 1 / 6),
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				BorderSizePixel = 0,
			}),
		},
	})
end

return UIDivision
