local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HealthBar = require(script.Parent.HealthBar)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

export type BillboardHealthBarProps = {
	currentHP: UsedAs<number>,
	maxHP: UsedAs<number>,

	Adornee: Instance,

	Size: UDim2?,
	StudsOffsetWorldSpace: Vector3?,
	AlwaysOnTop: boolean?,
}

local function BillboardHealthBar(scope: typeof(Fusion.scoped(Fusion)), props: BillboardHealthBarProps)
	local currentHP = props.currentHP
	local maxHP = props.maxHP

	if not props.Adornee then
		return
	end

	props.Size = props.Size or UDim2.new(4, 0, 0.4, 0)
	props.StudsOffsetWorldSpace = props.StudsOffsetWorldSpace or Vector3.new(0, 3.5, 0)
	props.AlwaysOnTop = props.AlwaysOnTop ~= nil and props.AlwaysOnTop or true

	return scope:New("BillboardGui")({
		Size = props.Size,
		StudsOffsetWorldSpace = props.StudsOffsetWorldSpace,
		Adornee = props.Adornee,
		AlwaysOnTop = props.AlwaysOnTop,
		[Children] = {
			HealthBar(
				scope,
				{
					currentHP = currentHP,
					maxHP = maxHP,

					Size = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
				} :: HealthBar.HealthBarProps
			),
		},
		Parent = props.Adornee,
	})
end

return BillboardHealthBar
