local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Children = Fusion.Children

local function AppButton(scope: typeof(Fusion.scoped(Fusion)), appName: string)
	return scope:New("ImageButton")({
		Name = "App_" .. appName,
		Size = UDim2.new(0.9, 0, 0.9, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(75, 75, 75),
		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.1, 0),
			}),
		},
	})
end

return AppButton
