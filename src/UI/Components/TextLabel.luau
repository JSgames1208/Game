local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIStroke = require(script.Parent.UIStroke)
local UICorner = require(script.Parent.UICorner)
local UIGradient = require(script.Parent.UIGradient)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Children = Fusion.Children

export type TextLabelProps = {
	Name: string?,
	Text: string,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	BackgroundTransparency: number?,
	BackgroundColor3: Color3? | ColorSequence?,
	TextColor3: Color3? | ColorSequence?,
	TextTransparency: number?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
	BackgroundColorRotation: number?,
	TextColorRotation: number?,
	FontFace: Font?,
	TextScaled: boolean?,
	TextSize: number?,
	ZIndex: number?,
	CornerRadius: UDim?,
	Stroke: { Thickness: number?, Color: Color3? | ColorSequence?, ColorRotation: number?, Transparency: number? }?,
	TextStroke: { Thickness: number?, Color: Color3? | ColorSequence?, ColorRotation: number?, Transparency: number? }?,
}

local function TextLabel(scope: typeof(Fusion.scoped(Fusion)), props: TextLabelProps)
	local s = scope:innerScope({
		UIStroke = UIStroke,
		UICorner = UICorner,
		UIGradient = UIGradient,
	})

	props.Name = props.Name or "TextLabel"
	props.BackgroundTransparency = props.BackgroundTransparency or 1
	props.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
	props.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255)
	props.TextScaled = if props.TextScaled == nil and props.TextSize == nil then true else props.TextScaled
	props.TextSize = if props.TextScaled == nil then props.TextSize else nil
	props.ZIndex = props.ZIndex or 1
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5)
	props.TextTransparency = props.TextTransparency or 0
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
	props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center

	props.FontFace = props.FontFace or Font.fromEnum(Enum.Font.FredokaOne)

	local Gradient
	if typeof(props.TextColor3) == "ColorSequence" then
		Gradient =
			s:UIGradient({ Color = props.TextColor3, Rotation = props.TextColorRotation } :: UIGradient.UIGradientProps)
		props.TextColor3 = Color3.fromRGB(255, 255, 255)
		props.BackgroundTransparency = 1
	end

	local Frame
	local BackgroundGradient

	Frame = scope:New("Frame")({
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = props.BackgroundColor3,
		ZIndex = props.ZIndex :: number - 2,
	})
	if typeof(props.BackgroundColor3) == "ColorSequence" then
		BackgroundGradient = s:UIGradient(
			{ Color = props.BackgroundColor3, Rotation = props.BackgroundColorRotation } :: UIGradient.UIGradientProps
		)
		BackgroundGradient.Parent = Frame
		props.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		props.BackgroundTransparency = 1
	end

	local Stroke
	if props.Stroke then
		props.Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
		Stroke = s:UIStroke(props.Stroke)
	end

	local t
	local TextStroke
	t = scope:New("TextLabel")({
		Text = props.Text,
		Size = UDim2.new(1, 0, 1, 0),
		Position = props.Position,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = props.FontFace,
		TextScaled = props.TextScaled,
		ZIndex = props.ZIndex :: number - 1,
		TextSize = props.TextSize or 1,

		AnchorPoint = Vector2.new(0.5, 0.5),
	})
	if props.TextStroke then
		props.TextStroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Contextual
		TextStroke = s:UIStroke(props.TextStroke)
		TextStroke.Parent = t
	end

	local Corner
	if props.CornerRadius then
		Corner = s:UICorner({ props.CornerRadius })
	end

	return scope:New("TextLabel")({
		Text = props.Text,
		Size = props.Size,
		Position = props.Position,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		TextColor3 = props.TextColor3,
		FontFace = props.FontFace,
		TextScaled = props.TextScaled,
		ZIndex = props.ZIndex,
		TextSize = props.TextSize or 1,
		TextTransparency = props.TextTransparency,

		TextXAlignment = props.TextXAlignment,
		TextYAlignment = props.TextYAlignment,

		AnchorPoint = Vector2.new(0.5, 0.5),

		[Children] = {
			Gradient,
			Frame,
			Stroke,
			t,
			Corner,
		},
	})
end

return TextLabel
