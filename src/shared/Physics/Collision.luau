local Collision = {}

function Collision.sweepRay(origins: { Vector3 }, movement: Vector3, ignoreList: { any }?)
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = ignoreList or {}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	for _, origin in origins do
		local result = workspace:Raycast(origin, movement, rayParams)
		if result then
			return result
		end
	end

	return nil
end

return Collision
