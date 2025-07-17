local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Bar = require(StarterGui.UI.Components.Bar)
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local typeLabels = {
	collect = "Collect",
	mine = "Mine",
	place = "Place",
	defeat = "Defeat",
}

local function Quest(
	scope: typeof(Fusion.scoped(Fusion)),
	progress: { UsedAs<number> },
	questComplete: UsedAs<boolean>,
	questId
)
	local quest = QuestData[questId]
	local objectives = quest.objectives
	local bars = {}

	for i, objective in ipairs(objectives) do
		local labelPrefix = typeLabels[objective.type] or objective.type

		local bar = Bar(
			scope,
			{
				Name = `{questId}/{objective.type}/{objective.id}`,
				PreText = `{labelPrefix} {objective.amount} {objective.id}: `,
				currentValue = progress[i],
				maxValue = objective.amount,
				BackgroundColor = Color3.fromRGB(60, 60, 60),
				BarColor = Color3.fromRGB(130, 130, 130),
				Size = UDim2.new(1, 0, 1 / 4, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				Children = {},
			} :: Bar.BarProps
		)

		table.insert(bars, bar)
	end

	local totalBars = #bars

	return scope:New("Frame")({
		Name = "TestFrame",
		Size = UDim2.new(0.9, 0, 0.9 * (totalBars + 1) / 4, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(110, 110, 110),
		BackgroundTransparency = 0,
		[Children] = {
			TextLabel(
				scope,
				{
					Text = quest.name,
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0, 0, 0, 0),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundColor3 = Color3.fromRGB(100, 100, 100),
					BackgroundTransparency = 0,
					TextScaled = true,
					Children = {
						scope:New("UIStroke")({
							Thickness = 3,
							Color = Color3.fromRGB(0, 0, 0),
							Enabled = true,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
						}),
					},
					SizeConstraint = Enum.SizeConstraint.RelativeXY,
					Size = UDim2.new(1, 0, 1 / (totalBars + 1), 0),
				} :: TextLabel.TextLabelProps
			),
			scope:New("Frame")({
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(60, 60, 60),
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 1 / (totalBars + 1), 0),
				Size = UDim2.new(1, 0, 1 - 1 / (totalBars + 1), 0),
				[Children] = {
					scope:New("UIListLayout")({
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
					table.unpack(bars),
				},
			}),
		},
	})
end

return Quest
