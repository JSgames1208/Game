local NormalMap = require(script.Parent.NormalMap)
local PlacementCalculator = {}

function PlacementCalculator.CalculatePlacePosition(
	worldPosition: Vector3,
	surface: Enum.NormalId,
	plotPosition: Vector3?
): Vector3
	local normal = NormalMap[surface]
	if not normal then
		return plotPosition or Vector3.zero
	end

	local basePos = if plotPosition then worldPosition - plotPosition else worldPosition

	return Vector3.new(
		math.floor(basePos.X / 4 + 0.5) + normal.X,
		math.floor(basePos.Y / 4 + 0.5) + normal.Y,
		math.floor(basePos.Z / 4 + 0.5) + normal.Z
	)
end

return PlacementCalculator
