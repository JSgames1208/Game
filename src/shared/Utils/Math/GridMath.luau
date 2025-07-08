local GridMath = {}

function GridMath.posToGridPos(pos: Vector3)
	return Vector3.new(math.floor(pos.X / 4 + 0.5), math.floor(pos.Y / 4 + 0.5), math.floor(pos.Z / 4 + 0.5))
end

function GridMath.gridPosToPos(gridPos: Vector3, plotPosition: Vector3)
	return gridPos * 4 + plotPosition
end

function GridMath.gridPosUnder(gridPos: Vector3)
	return gridPos + Vector3.new(0, -1, 0)
end

return GridMath
