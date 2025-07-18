local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

type UsedAs<T> = Fusion.UsedAs<T>

export type TextLabelProps = {
	AnchorPoint: Vector2?,
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,
	Name: string?,
	Position: UDim2?,
	Rotation: number?,
	Size: UDim2?,
	SizeConstraint: Enum.SizeConstraint?,
	Visible: boolean?,
	ZIndex: number?,
	ClipsDescendants: boolean?,
	FontFace: Font?,
	Text: UsedAs<string>?,
	TextColor3: Color3?,
	RichText: boolean?,
	TextScaled: boolean?,
	TextSize: number?,
	TextTransparency: UsedAs<number>?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,

	BobOnTextChange: boolean?,

	Children: typeof(Fusion.Children),
}

local function TextLabel(scope: typeof(Fusion.scoped(Fusion)), props: TextLabelProps)
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255)
	props.BackgroundTransparency = props.BackgroundTransparency or 0
	props.Name = props.Name or "TextLabel"
	props.Position = props.Position or UDim2.new(0, 0, 0, 0)
	props.Rotation = props.Rotation or 0
	props.Size = props.Size or UDim2.new(0, 100, 0, 50)
	props.SizeConstraint = props.SizeConstraint or Enum.SizeConstraint.RelativeXY
	props.Visible = props.Visible ~= nil and props.Visible or true
	props.ZIndex = props.ZIndex or 1
	props.ClipsDescendants = props.ClipsDescendants or false
	props.FontFace = props.FontFace or Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold)
	props.Text = props.Text or ""
	props.TextColor3 = props.TextColor3 or Color3.fromRGB(0, 0, 0)
	props.RichText = props.RichText or false
	props.TextScaled = props.TextScaled ~= nil and props.TextScaled or false
	props.TextSize = props.TextSize or 14
	props.TextTransparency = props.TextTransparency or 0
	props.TextWrapped = props.TextWrapped ~= nil and props.TextWrapped or false
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
	props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center

	props.BobOnTextChange = props.BobOnTextChange ~= nil and props.BobOnTextChange or false

	local targetScale = scope:Value(1)
	local animatedScale = scope:Tween(
		scope:Computed(function(use)
			return use(targetScale)
		end),
		TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	)

	if props.BobOnTextChange and typeof(props.Text) ~= "string" then
		local observer = scope:Observer(props.Text)
		observer:onChange(function()
			targetScale:set(1.2)
			task.delay(0.05, function()
				targetScale:set(1)
			end)
		end)
	end

	local size: UDim2 = props.Size :: UDim2

	return scope:New("TextLabel")({
		AnchorPoint = props.AnchorPoint,
		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency,
		Name = props.Name,
		Position = props.Position,
		Rotation = props.Rotation,
		Size = if not props.BobOnTextChange
			then props.Size
			else scope:Computed(function(use)
				return UDim2.new(size.X.Scale * use(animatedScale), 0, size.Y.Scale * use(animatedScale))
			end),
		SizeConstraint = props.SizeConstraint,
		Visible = props.Visible,
		ZIndex = props.ZIndex,
		ClipsDescendants = props.ClipsDescendants,
		FontFace = props.FontFace,
		Text = props.Text,
		TextColor3 = props.TextColor3,
		RichText = props.RichText,
		TextScaled = props.TextScaled,
		TextSize = props.TextSize,
		TextTransparency = props.TextTransparency,
		TextWrapped = props.TextWrapped,
		TextXAlignment = props.TextXAlignment,
		TextYAlignment = props.TextYAlignment,

		[Fusion.Children] = props.Children,
	})
end

return TextLabel
