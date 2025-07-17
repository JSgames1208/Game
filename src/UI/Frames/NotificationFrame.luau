local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local function NotificationFrame(scope: typeof(Fusion.scoped(Fusion)), notifications)
	return scope:New("Frame")({
		Name = "NotificationFrame",
		Size = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0.05, 0),
		BackgroundTransparency = 1,
		[Fusion.Children] = {
			scope:New("UIListLayout")({
				Name = "UIListLayout",
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			scope:Computed(function(use)
				local list = use(notifications)
				local items = {}
				for i, notification in ipairs(list) do
					table.insert(
						items,
						TextLabel(
							scope,
							{
								Text = notification.text,
								Size = UDim2.new(1, 0, 0.1, 0),
								TextScaled = true,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextTransparency = scope:Computed(function(use)
									return use(notification.fade)
								end),
								BackgroundTransparency = 1,
								Children = {
									scope:New("UIStroke")({
										Thickness = 3,
										Color = Color3.fromRGB(0, 0, 0),
										Transparency = scope:Computed(function(use)
											return use(notification.fade)
										end),
									}),
								},
							} :: TextLabel.TextLabelProps
						)
					)
				end
				return items
			end),
		},
	})
end

return NotificationFrame
