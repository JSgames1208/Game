local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local function QuestMarkerUI(scope: typeof(Fusion.scoped(Fusion)), enabled: UsedAs<boolean>)
	return scope:New("BillboardGui")({
		Name = "QuestMarkerUI",
		MaxDistance = 200,
		ResetOnSpawn = false,
		Size = UDim2.new(3, 0, 3, 0),
		StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0),
		ClipsDescendants = false,
		Enabled = scope:Computed(function(use)
			return use(enabled)
		end),
		[Children] = {
			TextLabel(
				scope,
				{
					Name = "Marker",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "!",
					FontFace = Font.fromEnum(Enum.Font.DenkOne),
					RichText = true,
					TextScaled = true,
					TextColor3 = Color3.fromRGB(255, 135, 66),
					Children = {
						scope:New("UIStroke")({
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Thickness = 2,
							Color = Color3.fromRGB(52, 52, 52),
						}),
					},
				} :: TextLabel.TextLabelProps
			),
		},
	})
end

return QuestMarkerUI
