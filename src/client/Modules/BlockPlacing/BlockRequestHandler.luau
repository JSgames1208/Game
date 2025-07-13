local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local StarterPlayer = game:GetService("StarterPlayer")
--local SoundService = require(StarterPlayer.StarterPlayerScripts.Client.Services.SoundService)
local packets = require(ReplicatedStorage.Shared.network)
local BlockRequestHandler = {}

function BlockRequestHandler.PlaceBlock(pos: Vector3, blockId: string, slot: number): ()
	packets.PlaceBlock.send({
		x = pos.X,
		y = pos.Y,
		z = pos.Z,
		blockId = blockId,
		slot = slot,
	})
end

packets.BlockPlaced.listen(function(vec3)
	--SoundService:Play("place", vec3)
end)

return BlockRequestHandler
