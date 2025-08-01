local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Button = require(StarterGui.UI.Components.Button)
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local UIStroke = require(StarterGui.UI.Components.UIStroke)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local ForValues = Fusion.ForValues
local OnEvent = Fusion.OnEvent

local MainGui = Players.LocalPlayer.PlayerGui:WaitForChild("MainGui")

type UsedAs<T> = Fusion.UsedAs<T>

export type DialogueFrameProps = {
	visible: UsedAs<boolean>,
	npcName: UsedAs<string>,
	text: UsedAs<string>,
	options: UsedAs<{ text: string, callback: string, shop: string? }>,
}

local function DialogueFrame(
	scope: typeof(Fusion.scoped(Fusion)),
	props: DialogueFrameProps,
	MouseEnter: () -> (),
	MouseLeave: () -> (),
	optionCallback
)
	return scope:New("Frame")({
		Name = "DialogueFrame",
		Size = UDim2.new(0.5, 0, 0.15, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(83, 83, 83),
		Position = UDim2.new(0.5, 0, 0.975, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		Visible = scope:Computed(function(use)
			MainGui.Enabled = not use(props.visible)
			return use(props.visible)
		end),
		[Children] = {
			scope:New("Frame")({
				Name = "NPCName",
				Size = UDim2.new(0.9, 0, 0.2, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.05, 0),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(60, 60, 60),
				[Children] = {
					TextLabel(
						scope,
						{
							Name = "NPCName",
							Size = UDim2.new(0.98, 0, 1, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							BackgroundTransparency = 1,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							Text = scope:Computed(function(use)
								return use(props.npcName)
							end),
							Children = {
								scope:New("UIStroke")({
									ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
									Thickness = 2,
								}),
							},
						} :: TextLabel.TextLabelProps
					),
				},
			}),
			TextLabel(
				scope,
				{
					Name = "Text",
					Text = scope:Computed(function(use)
						return use(props.text)
					end),
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(60, 60, 60),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					Size = UDim2.new(0.9, 0, 0.65, 0),
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.new(0.5, 0, 0.95, 0),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					Children = {
						scope:New("UIStroke")({
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Thickness = 2,
						}),
					},
				} :: TextLabel.TextLabelProps
			),

			scope:New("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 3,
				Color = Color3.fromRGB(42, 42, 42),
				Enabled = true,
			}),

			scope:New("Frame")({
				Name = "OptionsContainer",
				Size = UDim2.new(0.80, 0, 0.6, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 0.92, 0),
				BackgroundTransparency = 1,
				[Children] = {
					scope:New("UIListLayout")({
						Padding = UDim.new(0, 10),
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top,
					}),

					scope:ForValues(
						scope:Computed(function(use)
							return use(props.options) or {}
						end),
						function(use, scope, optionData)
							return Button(
								scope,
								{
									Name = "OptionButton",
									Size = UDim2.new(1, 0, 0.06, 0),
									SizeConstraint = Enum.SizeConstraint.RelativeXX,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.new(0.5, 0, 0.5, 0),
									BackgroundColor3 = Color3.fromRGB(50, 50, 50),
									OnClick = function()
										local cb = scope.peek(optionCallback)
										cb(optionData)
									end,
									Children = {
										TextLabel(
											scope,
											{
												Text = optionData.text,
												Size = UDim2.new(1, 0, 1, 0),
												Position = UDim2.new(0, 0, 0, 0),
												BackgroundTransparency = 1,
												TextColor3 = Color3.fromRGB(255, 255, 255),
												TextScaled = true,
												Children = {
													scope:New("UIStroke")({
														ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
														Thickness = 2,
														Color = Color3.fromRGB(0, 0, 0),
													}),
												},
											} :: TextLabel.TextLabelProps
										),
									},
								} :: Button.ButtonProps
							)
						end
					),
				},
			}),

			TextLabel(
				scope,
				{
					Text = "Click to continue!",
					Size = UDim2.new(0.3, 0, 0.05, 0),
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(0.99, 0, 1, 0),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Right,
					Children = {},
					Visible = scope:Computed(function(use)
						return #use(props.options) == 0
					end),
				} :: TextLabel.TextLabelProps
			),
		},

		[OnEvent("MouseEnter")] = MouseEnter,
		[OnEvent("MouseLeave")] = MouseLeave,
	})
end

return DialogueFrame
