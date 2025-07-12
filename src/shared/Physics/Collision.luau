local Players = game:GetService("Players")
local Collision = {}

function Collision.sweepRay(origins: { Vector3 }, movement: Vector3, ignoreList: { any }?)
	local rayParams = RaycastParams.new()

	local ignore: { any } = ignoreList or {}

	for _, player in Players:GetPlayers() do
		if player.Character then
			table.insert(ignore, player.Character)
		end
	end

	rayParams.FilterDescendantsInstances = ignore or {}
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
