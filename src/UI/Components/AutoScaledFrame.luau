local GameSize = Vector2.new(3839, 2159)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local Value = Fusion.Value
local Computed = Fusion.Computed
local OnChange = Fusion.OnChange

local function AutoScaledFrame(scope: typeof(Fusion.scoped(Fusion)), props)
	local GameSize = Vector2.new(3839, 2159)

	local scaleValue = scope:Value(1)

	-- Function to compute scale
	local function updateScale()
		local screenSize = workspace.CurrentCamera.ViewportSize
		local scaleX = screenSize.X / GameSize.X
		local scaleY = screenSize.Y / GameSize.Y
		local scale = math.max(scaleX, scaleY)
		scaleValue:set(scale)
	end

	-- Listen to screen size changes
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

	-- In case it doesn't fire, we also call once
	updateScale()

	return scope:New("Frame")({
		Size = props.Size,
		Position = UDim2.new(
			0,
			props.Position.X.Offset * scope.peek(scaleValue),
			0,
			props.Position.Y.Offset * scope.peek(scaleValue)
		),
		BackgroundTransparency = 1,
		[Children] = {
			scope:New("UIScale")({
				Scale = scaleValue,
			}),
		},
	})
end

return AutoScaledFrame
