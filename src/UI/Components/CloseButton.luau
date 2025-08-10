local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Button = require(script.Parent.Button)
local TextLabel = require(script.Parent.TextLabel)

local function CloseButton(scope: typeof(Fusion.scoped(Fusion)), scale: number, callback: () -> ())
	return Button(
		scope,
		{
			Name = "CloseButton",
			Size = UDim2.new(0.1 * scale, 0, 0.1 * scale, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			AnchorPoint = Vector2.new(0.8, 0.3),
			BackgroundColor3 = Color3.fromRGB(242, 34, 20),
			Position = UDim2.new(1, 0, 0, 0),

			OnClick = function()
				callback()
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
	)
end

return CloseButton
