local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local Button = require(StarterGui.UI.Components.Button)
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local RenderItemIcon = require(StarterPlayer.StarterPlayerScripts.Client.Modules.RenderItemIcon)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

export type ShopOptionProps = {
	mode: "buy" | "sell"?,
	shopId: string,
	shopStock: { [string]: { stock: number, lastRestock: number } }?,
	itemId: string,
	itemInfo: UsedAs<{ stock: UsedAs<number>, lastRestock: number }>,
	currency: UsedAs<number>,
	callback: (string, string, string) -> (),
}

local function ShopOption(scope: typeof(Fusion.scoped(Fusion)), props: ShopOptionProps)
	local viewport = scope:New("ViewportFrame")({
		Name = "IconViewport",
		Size = UDim2.new(0.9, 0, 0.9, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(0.95, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(83, 83, 83),
	})

	RenderItemIcon(viewport, props.itemId)

	scope:New("UIStroke")({
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 3,
		Color = Color3.fromRGB(60, 60, 60),
		Enabled = true,
		Parent = viewport,
	})

	return scope:New("Frame")({
		Name = "ShopOption",
		Size = UDim2.new(0.98, 0, 0.49, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),

		[Children] = {
			scope:New("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 3,
				Color = Color3.fromRGB(60, 60, 60),
				Enabled = true,
			}),
			TextLabel(
				scope,
				{
					Text = props.itemId,
					TextScaled = true,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Size = UDim2.new(0.5, 0, 0.2, 0),
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0.02, 0, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Children = {
						scope:New("UIStroke")({
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Thickness = 2,
							Color = Color3.fromRGB(0, 0, 0),
							Enabled = true,
						}),
					},
				} :: TextLabel.TextLabelProps
			),
			TextLabel(
				scope,
				{
					Text = scope:Computed(function(use)
						return `In stock: {use(scope.peek(props.itemInfo).stock)}`
					end),
					TextScaled = true,
					TextColor3 = Color3.fromRGB(210, 210, 210),
					BackgroundTransparency = 1,
					Size = UDim2.new(0.5, 0, 0.15, 0),
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0.02, 0, 0.2, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Children = {
						scope:New("UIStroke")({
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Thickness = 1,
							Color = Color3.fromRGB(0, 0, 0),
							Enabled = true,
						}),
					},
				} :: TextLabel.TextLabelProps
			),

			viewport,

			Button(
				scope,
				{
					Name = "Button",
					Size = UDim2.new(0.4, 0, 0.2, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.25, 0, 0.85, 0),
					BackgroundColor3 = Color3.fromRGB(0, 243, 4),
					OnClick = function()
						props.callback("buy", props.shopId, props.itemId)
					end,
					Children = {
						TextLabel(
							scope,
							{
								Text = "Buy",
								TextColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 1, 0),
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextScaled = true,
								Children = {
									scope:New("UIStroke")({
										ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
										Thickness = 3,
										Color = Color3.fromRGB(210, 210, 210),
										Enabled = true,
									}),
								},
							} :: TextLabel.TextLabelProps
						),

						scope:New("UIStroke")({
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Thickness = 3,
							Color = Color3.fromRGB(11, 210, 14),
							Enabled = true,
						}),
					},
				} :: Button.ButtonProps
			),
		},
	})
end

return ShopOption
