local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)

local BlockPlacer = {}

local normalMap = {
	[Enum.NormalId.Top] = Vector3.new(0, 1, 0),
	[Enum.NormalId.Bottom] = Vector3.new(0, -1, 0),
	[Enum.NormalId.Left] = Vector3.new(-1, 0, 0),
	[Enum.NormalId.Right] = Vector3.new(1, 0, 0),
	[Enum.NormalId.Front] = Vector3.new(0, 0, -1),
	[Enum.NormalId.Back] = Vector3.new(0, 0, 1),
}

function BlockPlacer.Start()
	Mouse.Button1Down:Connect(function() end)
end

function BlockPlacer.Place()
	local target = Mouse.Target
	if not target then
		return
	end

	local surface = Mouse.TargetSurface
	local normal = normalMap[surface]

	local blockId = "grass"

	if normal then
		local placePos = Vector3.new(
			math.floor(target.Position.X / 4 + 0.5) + normal.X,
			math.floor(target.Position.Y / 4 + 0.5) + normal.Y,
			math.floor(target.Position.Z / 4 + 0.5) + normal.Z
		)
		packets.PlaceBlock.send({
			x = placePos.X,
			y = placePos.Y,
			z = placePos.Z,
			blockId = blockId,
		})
	end
end

return BlockPlacer
