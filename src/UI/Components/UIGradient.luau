local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

export type UIGradientProps = {
	Color: ColorSequence,
	Rotation: number?,
}

local function UIGradient(scope: typeof(Fusion.scoped(Fusion)), props: UIGradientProps)
	props.Rotation = props.Rotation or 0
	return scope:New("UIGradient")({
		Color = props.Color,
		Rotation = props.Rotation,
	})
end

return UIGradient
