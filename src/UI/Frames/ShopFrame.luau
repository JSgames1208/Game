local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Button = require(StarterGui.UI.Components.Button)
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local ShopOption = require(StarterGui.UI.Features.Shop.ShopOption)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local Children = Fusion.Children

local PlayerGui = Players.LocalPlayer.PlayerGui
local MainGui = PlayerGui:WaitForChild("MainGui")
local DialogueGui = PlayerGui:WaitForChild("DialogueGui")

type UsedAs<T> = Fusion.UsedAs<T>

export type ShopFrameProps = {
	shopData: UsedAs<ShopData.ShopData>?,
	shopStock: UsedAs<{ [string]: { stock: number, lastRestock: number } }>?,
	visible: UsedAs<boolean>?,
}

local function ShopFrame(scope: typeof(Fusion.scoped(Fusion)), props: ShopFrameProps)
	if not props.shopData or not props.shopStock then
		return
	end

	local visible = props.visible

	if visible == nil then
		visible = scope:Value(false)
	end

	return scope:New("Frame")({
		Name = "ShopFrame",
		Size = UDim2.new(0.4, 0, 0.4, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		BackgroundColor3 = Color3.fromRGB(83, 83, 83),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Visible = scope:Computed(function(use)
			MainGui.Enabled = not use(props.visible)
			return use(props.visible)
		end),
		[Children] = {
			scope:New("ScrollingFrame")({
				Name = "ScrollingFrame",
				Size = UDim2.new(0.98, 0, 0.98, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,
				[Children] = {
					scope:New("UIListLayout")({
						Name = "UIListLayout",
						Padding = UDim.new(0, 10),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
					}),

					scope:ForPairs(props.shopStock, function(use, scope, itemId, item)
						print(props.shopStock)

						return itemId, ShopOption(scope, {
							itemId = itemId,
							itemInfo = item,
						})
					end),
				},
			}),
			scope:New("UICorner")({
				CornerRadius = UDim.new(0.05, 0),
			}),
			scope:New("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 3,
				Color = Color3.fromRGB(42, 42, 42),
				Enabled = true,
			}),
			TextLabel(
				scope,
				{
					Text = "Shop",
					AnchorPoint = Vector2.new(0.3, 0.4),
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0.4, 0, 0.1, 0),
					BackgroundTransparency = 1,
					TextScaled = true,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Children = {
						scope:New("UIStroke")({
							Thickness = 3,
							Color = Color3.fromRGB(0, 0, 0),
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Transparency = 0,
							Enabled = true,
						}),
					},
				} :: TextLabel.TextLabelProps
			),

			Button(
				scope,
				{
					Size = UDim2.new(0.1, 0, 0.1, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					AnchorPoint = Vector2.new(0.8, 0.3),
					BackgroundColor3 = Color3.fromRGB(242, 34, 20),
					Position = UDim2.new(1, 0, 0, 0),

					OnClick = function()
						visible:set(false)
					end,

					Children = {
						scope:New("UIStroke")({
							Thickness = 3,
							Color = Color3.fromRGB(192, 0, 0),
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Transparency = 0,
							Enabled = true,
						}),

						scope:New("UICorner")({
							CornerRadius = UDim.new(1, 0),
						}),

						TextLabel(
							scope,
							{
								Size = UDim2.new(1, 0, 1, 0),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Text = "X",
								FontFace = Font.fromEnum(Enum.Font.FredokaOne),
								BackgroundTransparency = 1,
								TextScaled = true,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								Children = {
									scope:New("UIStroke")({
										Thickness = 2,
										Color = Color3.fromRGB(210, 210, 210),
										ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
										Transparency = 0,
										Enabled = true,
									}),
								},
							} :: TextLabel.TextLabelProps
						),
					},
				} :: Button.ButtonProps
			),
		},
	})
end

return ShopFrame
