local BlockHelpers = {}

function BlockHelpers.GetBottomCorners(center: Vector3, halfSize: Vector3)
	return {
		center + Vector3.new(-halfSize.X, -halfSize.Y, -halfSize.Z),
		center + Vector3.new(halfSize.X, -halfSize.Y, -halfSize.Z),
		center + Vector3.new(-halfSize.X, -halfSize.Y, halfSize.Z),
		center + Vector3.new(halfSize.X, -halfSize.Y, halfSize.Z),
		center + Vector3.new(0, -halfSize.Y, 0),
	}
end

return BlockHelpers
