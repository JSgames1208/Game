local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextLabel = require(StarterGui.UI.Components.TextLabel)
local UIStroke = require(StarterGui.UI.Components.UIStroke)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local MainGui = Players.LocalPlayer.PlayerGui:WaitForChild("MainGui")

type UsedAs<T> = Fusion.UsedAs<T>

export type DialogueFrameProps = {
	visible: UsedAs<boolean>,
	text: UsedAs<string>,
	options: UsedAs<{ text: string, callback: string, shop: string? }>,
}

local function DialogueFrame(
	scope: typeof(Fusion.scoped(Fusion)),
	props: DialogueFrameProps,
	MouseEnter: () -> (),
	MouseLeave: () -> ()
)
	return scope:New("Frame")({
		Name = "DialogueFrame",
		Size = UDim2.new(0.5, 0, 0.075, 0),
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
			TextLabel(
				scope,
				{
					Name = "Text",
					Text = scope:Computed(function(use)
						return use(props.text)
					end),
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(0.9, 0, 0.9, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Children = {
						scope:New("UIStroke")({
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
							Thickness = 2,
						}),
					},
				} :: TextLabel.TextLabelProps
			),
		},

		[OnEvent("MouseEnter")] = MouseEnter,
		[OnEvent("MouseLeave")] = MouseLeave,
	})
end

return DialogueFrame
