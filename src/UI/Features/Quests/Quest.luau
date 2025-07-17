local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Bar = require(StarterGui.UI.Components.Bar)
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local QuestData = require(ReplicatedStorage.Shared.Data.QuestData)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local function Quest(
	scope: typeof(Fusion.scoped(Fusion)),
	progress: { collect: { [string]: UsedAs<number> }?, mine: { [string]: UsedAs<number> }? },
	questComplete: UsedAs<boolean>,
	questId
)
	local quest = QuestData[questId]

	local collectCount = 0
	if progress.collect then
		for _, _ in progress.collect do
			collectCount += 1
		end
	end

	local mineCount = 0
	if progress.mine then
		for _, _ in progress.mine do
			mineCount += 1
		end
	end

	local barCount = collectCount + mineCount

	local bars = {}

	for item, amount in quest.requirements.collect do
		if progress.collect then
			local bar = Bar(
				scope,
				{
					Name = questId .. "/" .. item,
					PreText = "Collect " .. tostring(amount) .. " " .. item .. ": ",
					currentValue = progress.collect[item],
					maxValue = amount,
					questComplete = questComplete,
					BackgroundColor = Color3.fromRGB(60, 60, 60),
					BarColor = Color3.fromRGB(130, 130, 130),
					Size = UDim2.new(1, 0, 1 / 4, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Children = {},
				} :: Bar.BarProps
			)
			table.insert(bars, bar)
		end
	end

	for item, amount in quest.requirements.mine do
		if progress.mine then
			local bar = Bar(
				scope,
				{
					Name = questId .. "/" .. item,
					PreText = "Break " .. tostring(amount) .. " " .. item .. ": ",
					currentValue = progress.mine[item],
					maxValue = amount,
					questComplete = questComplete,
					BackgroundColor = Color3.fromRGB(60, 60, 60),
					BarColor = Color3.fromRGB(130, 130, 130),
					Size = UDim2.new(1, 0, 1 / 4, 0),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					Children = {},
				} :: Bar.BarProps
			)
			table.insert(bars, bar)
		end
	end

	return scope:New("Frame")({
		Name = "TestFrame",
		Size = UDim2.new(0.9, 0, 0.9 * (barCount + 1) / 4, 0),
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
					Size = UDim2.new(1, 0, 1 / (barCount + 1), 0),
				} :: TextLabel.TextLabelProps
			),
			scope:New("Frame")({
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(60, 60, 60),
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 1 / (barCount + 1), 0),
				Size = UDim2.new(1, 0, 1 - 1 / (barCount + 1), 0),
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
