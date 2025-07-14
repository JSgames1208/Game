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

	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.Name = props.Name or "Frame"
	props.Position = props.Position or UDim2.new(0, 0, 0, 0)

	local scaleValue = scope:Value(1)

	-- Function to compute scale
	local function updateScale()
		local screenSize = workspace.CurrentCamera.ViewportSize
		local scaleX = screenSize.X / GameSize.X
		local scaleY = screenSize.Y / GameSize.Y
		local scale = (scaleX * 0.5) + (scaleY * 0.5)
		scaleValue:set(scale)
	end

	-- Listen to screen size changes
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

	-- In case it doesn't fire, we also call once
	updateScale()

	local scaledPosition = scope:Computed(function(use)
		local scale = use(scaleValue)
		return UDim2.new(
			props.Position.X.Scale,
			props.Position.X.Offset * scale,
			props.Position.Y.Scale,
			props.Position.Y.Offset * scale
		)
	end)

	return scope:New("Frame")({
		Name = props.Name,
		Size = props.Size,
		AnchorPoint = props.AnchorPoint,
		Position = scaledPosition,
		BackgroundTransparency = 1,
		[Children] = {
			scope:New("UIScale")({
				Scale = scaleValue,
			}),
		},
	})
end

return AutoScaledFrame
