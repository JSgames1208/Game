local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextLabel = require(script.Parent.TextLabel)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

export type BarProps = {
	Name: string?,
	PreText: string?,
	currentValue: UsedAs<number>,
	maxValue: number,
	BackgroundColor: Color3,
	BarColor: Color3,
	Size: UDim2,
	SizeConstraint: Enum.SizeConstraint?,
	Position: UDim2,
	AnchorPoint: Vector2?,
	Children: typeof(Children),
}

local function Bar(scope: typeof(Fusion.scoped(Fusion)), props: BarProps)
	props.Name = props.Name or "Bar"
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.PreText = props.PreText or ""
	props.SizeConstraint = props.SizeConstraint or Enum.SizeConstraint.RelativeXY

	local currentValue = props.currentValue
	local maxValue = props.maxValue

	return scope:New("Frame")({
		Name = props.Name,
		AnchorPoint = props.AnchorPoint,
		Size = props.Size,
		Position = props.Position,
		BackgroundColor3 = props.BackgroundColor,
		BackgroundTransparency = 1,
		SizeConstraint = props.SizeConstraint,
		[Children] = {
			scope:New("Frame")({
				Name = "Background",
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = props.BackgroundColor,
			}),
			scope:New("Frame")({
				Name = "Bar",
				AnchorPoint = Vector2.new(0, 0),
				Size = scope:Tween(
					scope:Computed(function(use)
						return UDim2.new(use(currentValue) / maxValue, 0, 1, 0)
					end),
					TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
				),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = props.BarColor,
			}),
			TextLabel(
				scope,
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0.4, 0, 1.1, 0),
					BackgroundTransparency = 1,
					BobOnTextChange = true,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Text = scope:Computed(function(use)
						return props.PreText :: string .. tostring(use(currentValue)) .. "/" .. (tostring(maxValue))
					end),
					TextScaled = true,
					ZIndex = 2,
					Children = {
						scope:New("UIStroke")({
							Thickness = 5,
							Color = Color3.fromRGB(0, 0, 0),
						}),
					},
				} :: TextLabel.TextLabelProps
			),
			props.Children,
		},
	})
end

return Bar
