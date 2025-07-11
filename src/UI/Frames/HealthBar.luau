local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

export type HealthBarProps = {
	currentHP: number,
	maxHP: number,
	adornee: Part | Model | MeshPart,
}

local function HealthBar(scope: typeof(Fusion), props)
	local currentHP = props.currentHP
	local maxHP = props.maxHP

	return scope:New("BillboardGui")({
		Size = UDim2.new(4, 0, 0.4, 0),
		StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0),
		Adornee = props.adornee,
		[Children] = {
			scope:New("Frame")({
				Name = "Background",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(199, 16, 16),
			}),
			scope:New("Frame")({
				Name = "Health",
				Size = scope:Computed(function(use)
					local hp = use(currentHP)
					local max = use(maxHP)
					return UDim2.new(hp / max, 0, 1, 0)
				end),
				BackgroundColor3 = Color3.fromRGB(38, 227, 9),
			}),
		},
		Parent = props.adornee,
	})
end

return HealthBar
