local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Button = require(StarterGui.UI.Components.Button)
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local ImageIds = require(StarterGui.UI.ImageIds)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local function TestFrame(scope: typeof(Fusion.scoped(Fusion)))
	local visible = scope:Value(false)
	local goalAnchor = scope:Value(Vector2.new(1, 0))

	local screenSize = scope:Value(workspace.CurrentCamera.ViewportSize)
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		screenSize:set(workspace.CurrentCamera.ViewportSize)
	end)

	print(scope.peek(screenSize))

	return scope:New("Frame")({
		Name = "QuestFrame",
		Size = UDim2.new(0.2, 0, 1, 0),
		AnchorPoint = scope:Spring(goalAnchor, 20, 1),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(83, 83, 83),
		BackgroundTransparency = 0,
		[Children] = {
			Button(
				scope,
				{
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(1.05, 0, 0.5, 0),
					Size = UDim2.new(0.033, 0, 0.1, 0),
					BackgroundTransparency = 1,
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					Image = ImageIds.QuestOpen,
					OnClick = function()
						if scope.peek(visible) then
							goalAnchor:set(Vector2.new(1, 0))
						else
							goalAnchor:set(Vector2.new(0, 0))
						end
						task.delay(0.1, function()
							visible:set(not scope.peek(visible))
						end)
					end,
					Children = {},
				} :: Button.ButtonProps
			),
			scope:New("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 3,
				Color = Color3.fromRGB(42, 42, 42),
				Enabled = scope:Computed(function(use)
					return use(visible)
				end),
			}),
			TextLabel(
				scope,
				{
					Text = "Quests",
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					TextScaled = true,
					Children = {
						scope:New("UIStroke")({
							Thickness = 3,
							Color = Color3.fromRGB(0, 0, 0),
							Enabled = true,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
						}),
					},
					Size = scope:Computed(function(use)
						return UDim2.new(1, 0, 0, use(screenSize).X / 25)
					end),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
				} :: TextLabel.TextLabelProps
			),
			scope:New("ScrollingFrame")({
				Name = "ScrollingFrame",
				BackgroundTransparency = 1,
				Size = scope:Computed(function(use)
					return UDim2.new(1, 0, 0, use(screenSize).Y - (use(screenSize).X / 25))
				end),
				SizeConstraint = Enum.SizeConstraint.RelativeXY,
				AnchorPoint = Vector2.new(0, 0),
				Position = scope:Computed(function(use)
					print(use(screenSize))
					return UDim2.new(0, 0, 0, use(screenSize).X / 25)
				end),
			}),
		},
	})
end

return TestFrame
