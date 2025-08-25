local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlayerEntity = require(ReplicatedStorage.Shared.Entity.Player.PlayerEntity)
local Entity = require(script.Parent.Entity)
local EntityStorage = require(script.Parent.EntityStorage)
local FallingBlockEntity = require(script.Parent.FallingBlockEntity)
local ItemEntity = require(script.Parent.ItemEntity)
local EntityService = {}

function EntityService.Start()
	RunService.Heartbeat:Connect(function(dt: number)
		local Entities: { Entity.Entity } = EntityStorage.get()
		for i = #Entities, 1, -1 do
			local entity = Entities[i]
			if entity.isDestroyed then
				table.remove(Entities, i)
			end
		end

		for _, entity in Entities do
			entity:update(dt)
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
	EntityStorage.register(fallingBlock.model, fallingBlock)
end

function EntityService.SpawnItemEntity(player: Player, pos: Vector3, itemId: string, amount: number?)
	local itemEntity = ItemEntity.new(player, pos, itemId, amount)
	EntityStorage.register(itemEntity.model, itemEntity)
end

function EntityService.PlayerJoined(player: Player)
	local playerEntity = PlayerEntity.new(player, Vector3.new(0, 0, 0))
	EntityStorage.register(playerEntity.model, playerEntity)
end

function EntityService.PlayerLeaving(player: Player)
	if player.Character then
		EntityStorage.remove(player.Character:FindFirstChild("CollisionPart"))
	end
end

return EntityService
