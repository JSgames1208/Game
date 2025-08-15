local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Children = Fusion.Children

local function AppBar(scope: typeof(Fusion.scoped(Fusion)))
	return scope:New("Frame")({
		Name = "AppBar",
		Size = UDim2.new(1, 0, 0, 40),
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BackgroundTransparency = 0.03,
		[Children] = {
			scope:New("UIStroke")({
				Thickness = 1,
				Color = Color3.fromRGB(100, 100, 100),
			}),
		},
	})
end

return AppBar
