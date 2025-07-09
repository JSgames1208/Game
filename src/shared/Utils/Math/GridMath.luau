local GridMath = {}

function GridMath.posToGridPos(pos: Vector3, plotPosition: Vector3)
	local relativePos = pos - plotPosition
	return Vector3.new(
		math.floor(relativePos.X / 4 + 0.5),
		math.floor(relativePos.Y / 4 + 0.5),
		math.floor(relativePos.Z / 4 + 0.5)
	)
end

function GridMath.gridPosToPos(gridPos: Vector3, plotPosition: Vector3)
	return gridPos * 4 + plotPosition
end

function GridMath.gridPosUnder(gridPos: Vector3)
	return gridPos + Vector3.new(0, -1, 0)
end

return GridMath
