local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local AppIcons = require(StarterPlayer.StarterPlayerScripts.Client.Admin.AppIcons)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local OnEvent = Fusion.OnEvent

local Children = Fusion.Children

local function AppButton(scope: typeof(Fusion.scoped(Fusion)), appName: string, mouseDown: () -> (), mouseUp: () -> ())
	return scope:New("ImageButton")({
		Name = "App_" .. appName,
		Image = AppIcons[appName] or "",
		Size = UDim2.new(0.9, 0, 0.9, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(75, 75, 75),
		[OnEvent("MouseButton1Down")] = mouseDown,
		[OnEvent("MouseButton1Up")] = mouseUp,
		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.1, 0),
			}),
		},
	})
end

return AppButton
