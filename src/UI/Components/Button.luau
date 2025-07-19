local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local OnEvent = Fusion.OnEvent

export type ButtonProps = {
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
	HoverImage: string?,
	Image: string?,
	ImageColor3: Color3?,
	ImageTransparency: number?,
	PressedImage: string?,
	ScaleType: Enum.ScaleType?,
	OnClick: (() -> ())?,
	Children: typeof(Fusion.Children),
}

local function Button(scope: typeof(Fusion.scoped(Fusion)), props: ButtonProps)
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	props.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255)
	props.BackgroundTransparency = props.BackgroundTransparency or 0
	props.Name = props.Name or "Button"
	props.Position = props.Position or UDim2.new(0, 0, 0, 0)
	props.Rotation = props.Rotation or 0
	props.Size = props.Size or UDim2.new(0, 100, 0, 100)
	props.SizeConstraint = props.SizeConstraint or Enum.SizeConstraint.RelativeXY
	props.Visible = props.Visible ~= nil and props.Visible or true
	props.ZIndex = props.ZIndex or 1
	props.ClipsDescendants = props.ClipsDescendants or false
	props.HoverImage = props.HoverImage or ""
	props.Image = props.Image or ""
	props.ImageColor3 = props.ImageColor3 or Color3.fromRGB(255, 255, 255)
	props.ImageTransparency = props.ImageTransparency or 0
	props.PressedImage = props.PressedImage or ""
	props.ScaleType = props.ScaleType or Enum.ScaleType.Stretch

	props.OnClick = props.OnClick or function()
		return
	end

	local targetScale = scope:Value(1)
	local animatedScale = scope:Spring(targetScale, 35, 1)

	local function onEnter()
		targetScale:set(1.075)
	end
	local function onLeave()
		targetScale:set(1)
	end
	local function onDown()
		targetScale:set(0.9275)
	end
	local function onUp()
		targetScale:set(1.075)
	end

	local size: UDim2 = props.Size :: UDim2

	return scope:New("ImageButton")({
		AnchorPoint = props.AnchorPoint,
		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency,
		Name = props.Name,
		Position = props.Position,
		Rotation = props.Rotation,
		Size = scope:Computed(function(use)
			return UDim2.new(size.X.Scale * use(animatedScale), 0, size.Y.Scale * use(animatedScale), 0)
		end),
		SizeConstraint = props.SizeConstraint,
		Visible = props.Visible,
		ZIndex = props.ZIndex,
		ClipsDescendants = props.ClipsDescendants,
		HoverImage = props.HoverImage,
		Image = props.Image,
		ImageColor3 = props.ImageColor3,
		ImageTransparency = props.ImageTransparency,
		PressedImage = props.PressedImage,
		ScaleType = props.ScaleType,

		[Fusion.Children] = props.Children,

		[OnEvent("MouseEnter")] = onEnter,
		[OnEvent("MouseLeave")] = onLeave,
		[OnEvent("MouseButton1Down")] = onDown,
		[OnEvent("MouseButton1Up")] = onUp,
		[OnEvent("MouseButton1Click")] = props.OnClick,
	})
end

return Button
