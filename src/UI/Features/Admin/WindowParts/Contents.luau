local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local function Contents(scope: typeof(Fusion.scoped(Fusion)), appName): Frame
	return scope:New("Frame")({
		Name = "Contents",
		Size = UDim2.new(1, 0, 1, -25),
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 1,
	}) :: Frame
end

return Contents
