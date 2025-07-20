local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

export type ShopOptionProps = {
	mode: "buy" | "sell"?,
	shopId: string?,
	shopStock: { [string]: { stock: number, lastRestock: number } }?,
	itemId: string,
	itemInfo: { stock: number, lastRestock: number },
}

local function ShopOption(scope: typeof(Fusion.scoped(Fusion)), props: ShopOptionProps)
	print("Flipping option broooo", props.itemId, props.itemInfo)

	return scope:New("Frame")({
		Name = "ShopOption",
		Size = UDim2.new(1, 0, 0.5, 0),
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
					Text = "In stock: " .. tostring(props.itemInfo.stock),
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
		},
	})
end

return ShopOption
