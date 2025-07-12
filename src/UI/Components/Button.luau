local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIStroke = require(script.Parent.UIStroke)
local UICorner = require(script.Parent.UICorner)
local UIGradient = require(script.Parent.UIGradient)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

local SIZE_HOVER = 1.15
local SIZE_HELD = 0.85

export type ButtonProps = {
	Name: string?,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	BackgroundTransparency: number?,
	BackgroundColor3: Color3?,
	ImageId: string?,
	ZIndex: number?,
	CornerRadius: UDim?,
	Stroke: { Thickness: number?, Color: Color3? | ColorSequence?, ColorRotation: number?, Transparency: number? }?,

	OnClick: (() -> ())?,
}

local function Button(scope: typeof(Fusion.scoped(Fusion)), props: ButtonProps)
	local s = scope:innerScope({
		UIStroke = UIStroke,
		UICorner = UICorner,
		UIGradient = UIGradient,
	})

	local isHovering = scope:Value(false)
	local isHeldDown = scope:Value(false)

	props.Name = props.Name or "Button"
	props.BackgroundTransparency = props.BackgroundTransparency or 1
	props.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255)
	props.ZIndex = props.ZIndex or 1
	props.AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5)
	props.ImageId = props.ImageId or ""
	props.Size = props.Size or UDim2.new(0.1, 0, 0.1, 0)

	local Stroke
	if props.Stroke then
		props.Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
		Stroke = s:UIStroke(props.Stroke)
	end

	local Corner
	if props.CornerRadius then
		Corner = s:UICorner({ props.CornerRadius })
	end

	local size: UDim2 = props.Size :: UDim2

	local originalSize = UDim2.fromScale(size.X.Scale, size.Y.Scale)

	return scope:New("ImageButton")({
		Name = props.Name,
		Position = props.Position,
		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = 1,
		ZIndex = props.ZIndex,
		Image = props.ImageId,

		AnchorPoint = props.AnchorPoint,

		Size = scope:Spring(
			scope:Computed(function(use)
				return if use(isHeldDown)
					then UDim2.fromScale(originalSize.X.Scale * SIZE_HELD, originalSize.Y.Scale * SIZE_HELD)
					elseif use(isHovering) then UDim2.fromScale(
						originalSize.X.Scale * SIZE_HOVER,
						originalSize.Y.Scale * SIZE_HOVER
					)
					else originalSize
			end),
			40
		),

		[OnEvent("Activated")] = function()
			if props.OnClick ~= nil then
				props.OnClick()
			end
		end,

		[OnEvent("MouseButton1Down")] = function()
			isHeldDown:set(true)
		end,

		[OnEvent("MouseButton1Up")] = function()
			isHeldDown:set(false)
		end,

		[OnEvent("MouseEnter")] = function()
			isHovering:set(true)
		end,

		[OnEvent("MouseLeave")] = function()
			isHeldDown:set(false)
			isHovering:set(false)
		end,

		[Children] = {
			Stroke,
			Corner,
		},
	})
end

return Button
