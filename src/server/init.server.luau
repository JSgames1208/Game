local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)
local IslandManager = require(script.Islands.IslandManager)

Players.PlayerAdded:Connect(function(player: Player)
	IslandManager.PlayerJoined(player)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	IslandManager.PlayerLeaving(player)
end)

packets.PlaceBlock.listen(function(data, player)
	local pos = Vector3.new(data.x, data.y, data.z)
	IslandManager.PlaceBlock(player, pos, data.blockId)
end)
