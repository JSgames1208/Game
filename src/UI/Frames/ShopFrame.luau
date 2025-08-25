local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local CloseButton = require(StarterGui.UI.Components.CloseButton)
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local ShopOption = require(StarterGui.UI.Features.Shop.ShopOption)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local ShopData = require(ReplicatedStorage.Shared.Data.ShopData)
local TimeFormatter = require(ReplicatedStorage.Shared.Utils.String.TimeFormatter)
local Children = Fusion.Children

local PlayerGui = Players.LocalPlayer.PlayerGui
local MainGui = PlayerGui:WaitForChild("MainGui")

type UsedAs<T> = Fusion.UsedAs<T>

export type ShopFrameProps = {
	shopData: UsedAs<ShopData.ShopData>?,
	shopStock: UsedAs<{ [string]: { stock: UsedAs<number>, lastRestock: number, id: string } }>?,
	visible: UsedAs<boolean>?,
	currency: UsedAs<number>?,
	timeTillRestock: UsedAs<number>?,
	buttonCallback: (string, string, string) -> ()?,
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
				Size = UDim2.new(1, 0, 0.96, 0),
				CanvasSize = scope:Computed(function(use)
					return UDim2.new(0, 0, #use(props.shopStock) / 2.0, (#use(props.shopStock) - 1) * 10)
				end),
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

					scope:ForValues(props.shopStock, function(use, scope, item)
						return ShopOption(scope, {
							itemId = item.id,
							itemInfo = item,
							shopId = scope.peek(props.shopData).id,
							currency = props.currency,
							callback = props.buttonCallback,
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
				Color = Color3.fromRGB(60, 60, 60),
				Enabled = true,
			}),
			TextLabel(
				scope,
				{
					Text = "Shop",
					AnchorPoint = Vector2.new(0.25, 0.65),
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0.4, 0, 0.15, 0),
					BackgroundTransparency = 1,
					TextScaled = true,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Children = {
						scope:New("UIStroke")({
							Thickness = 4,
							Color = Color3.fromRGB(0, 0, 0),
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Transparency = 0,
							Enabled = true,
						}),
					},
				} :: TextLabel.TextLabelProps
			),

			CloseButton(scope, 1, function()
				visible:set(false)
			end),

			TextLabel(
				scope,
				{
					Text = scope:Computed(function(use)
						return `${use(props.currency)}`
					end),
					BackgroundColor3 = Color3.fromRGB(83, 83, 83),
					BackgroundTransparency = 0,
					TextScaled = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0, 0),
					Size = UDim2.new(0.4, 0, 0.1, 0),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Children = {
						scope:New("UIStroke")({
							Thickness = 2,
							Color = Color3.fromRGB(0, 0, 0),
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Transparency = 0,
							Enabled = true,
						}),
						scope:New("UIStroke")({
							Thickness = 3,
							Color = Color3.fromRGB(60, 60, 60),
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Transparency = 0,
							Enabled = true,
						}),
						scope:New("UICorner")({
							CornerRadius = UDim.new(1, 0),
						}),
					},
				} :: TextLabel.TextLabelProps
			),

			TextLabel(
				scope,
				{
					Text = scope:Computed(function(use)
						return `Restocks in {TimeFormatter(use(props.timeTillRestock))}`
					end),
					BackgroundColor3 = Color3.fromRGB(83, 83, 83),
					BackgroundTransparency = 0,
					TextScaled = true,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1.05, 0, 1, 0),
					Size = UDim2.new(0.3, 0, 0.08, 0),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Children = {
						scope:New("UIStroke")({
							Thickness = 2,
							Color = Color3.fromRGB(0, 0, 0),
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Transparency = 0,
							Enabled = true,
						}),
						scope:New("UIStroke")({
							Thickness = 3,
							Color = Color3.fromRGB(60, 60, 60),
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Transparency = 0,
							Enabled = true,
						}),
						scope:New("UICorner")({
							CornerRadius = UDim.new(1, 0),
						}),
					},
				} :: TextLabel.TextLabelProps
			),
		},
	})
end

return ShopFrame
