local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

export type HealthBarProps = {
	currentHP: UsedAs<number>,
	maxHP: UsedAs<number>,

	Size: UsedAs<UDim2>?,
	SizeConstraint: Enum.SizeConstraint?,
	Position: UsedAs<UDim2>?,
	AnchorPoint: Vector2?,

	AddText: boolean?,
}

local function HealthBar(scope: typeof(Fusion), props: HealthBarProps)
	local currentHP = props.currentHP
	local maxHP = props.maxHP

	props.Size = props.Size or UDim2.new(1, 0, 1, 0)
	props.SizeConstraint = props.SizeConstraint or Enum.SizeConstraint.RelativeXY
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.Position = props.Position or UDim2.new(0, 0, 0, 0)

	props.AddText = props.AddText ~= nil and props.AddText or false

	local text = nil

	if props.AddText then
		text = TextLabel(
			scope,
			{
				Size = UDim2.new(1, 0, 2, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextScaled = true,
				BackgroundTransparency = 1,
				Text = scope:Computed(function(use)
					return `{use(currentHP)}/{use(maxHP)}`
				end),
				Children = {
					scope:New("UIStroke")({
						Thickness = 2,
						Color = Color3.fromRGB(0, 0, 0),
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
						Transparency = 0,
						Enabled = true,
					}),
				},
			} :: TextLabel.TextLabelProps
		)
	end

	return scope:New("Frame")({
		AnchorPoint = props.AnchorPoint,
		Size = props.Size,
		SizeConstraint = props.SizeConstraint,
		Position = scope:Computed(function(use)
			return use(props.Position)
		end),
		[Children] = {
			scope:New("Frame")({
				Name = "Background",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(199, 16, 16),
			}),
			scope:New("Frame")({
				Name = "Health",
				Size = scope:Spring(
					scope:Computed(function(use)
						local hp = use(currentHP)
						local max = use(maxHP)
						return UDim2.new(hp / max, 0, 1, 0)
					end),
					30,
					1
				),
				BackgroundColor3 = Color3.fromRGB(38, 227, 9),
			}),

			text,
		},
	})
end

return HealthBar
