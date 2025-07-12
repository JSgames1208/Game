local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIGradient = require(script.Parent.UIGradient)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

export type UIStrokeProps = {
	ApplyStrokeMode: Enum.ApplyStrokeMode,
	Color: Color3? | ColorSequence?,
	ColorRotation: number?,
	Thickness: number?,
	Transparency: number?,
	Enabled: boolean?,
}

local function UIStroke(scope: typeof(Fusion.scoped(Fusion)), props: UIStrokeProps)
	local s = scope:innerScope({
		UIGradient = UIGradient,
	})

	props.Color = props.Color or Color3.fromRGB(255, 255, 255)
	props.Thickness = props.Thickness or 1
	props.Transparency = props.Transparency or 0
	props.ColorRotation = props.ColorRotation or 0
	props.Enabled = props.Enabled or false

	local UIGradient
	if typeof(props.Color) == "ColorSequence" then
		UIGradient = s:UIGradient({ Color = props.Color, Rotation = props.ColorRotation } :: UIGradient.UIGradientProps)
		props.Color = Color3.fromRGB(255, 255, 255)
	end

	return scope:New("UIStroke")({
		ApplyStrokeMode = props.ApplyStrokeMode,
		Thickness = props.Thickness,
		Color = props.Color,
		Transparency = props.Transparency or 0,
		Enabled = props.Enabled,

		[Children] = {
			UIGradient,
		},
	})
end

return UIStroke
