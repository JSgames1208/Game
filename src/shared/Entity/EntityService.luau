local RunService = game:GetService("RunService")
local FallingBlockEntity = require(script.Parent.FallingBlockEntity)
local EntityService = {}

local Entities = {}

function EntityService.Start()
	RunService.Heartbeat:Connect(function(dt: number)
		for i = #Entities, 1, -1 do
			local entity = Entities[i]
			if entity.isDestroyed then
				table.remove(Entities, i)
			end
		end

		for _, entity in Entities do
			entity:Update(dt)
		end
	end)
end

function EntityService.SpawnFallingBlock(
	player: Player,
	pos: Vector3,
	blockId: string,
	callback: (Player, Vector3, string) -> ()
)
	local fallingBlock = FallingBlockEntity.new(player, pos, blockId, callback)
	table.insert(Entities, fallingBlock)
end

return EntityService
