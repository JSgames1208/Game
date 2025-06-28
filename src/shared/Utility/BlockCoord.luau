local BlockCoord = {}

function BlockCoord.ParsePos(posStr: string)
	local x, y, z = posStr:match("(-?%d+),(-?%d+),(-?%d+)")
	return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
end

function BlockCoord.GetName(pos: Vector3)
	return tostring(pos.X) .. "," .. tostring(pos.Y) .. "," .. tostring(pos.Z)
end

return BlockCoord
