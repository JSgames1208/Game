local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

export type UICornerProps = {
	CornerRadius: UDim,
}

local function UICorner(scope: typeof(Fusion.scoped(Fusion)), props: UICornerProps)
	return scope:New("UICorner")({
		CornerRadius = props.CornerRadius,
	})
end

return UICorner
