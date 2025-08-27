local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStore = require(script.Parent.DataStore)
local Entity = require(ServerScriptService.Server.Entity.Entity)
local EntityStorage = require(ServerScriptService.Server.Entity.EntityStorage)
local FallingBlockEntity = require(ServerScriptService.Server.Entity.FallingBlockEntity)
local ItemEntity = require(ServerScriptService.Server.Entity.ItemEntity)
local PlayerEntity = require(ServerScriptService.Server.Entity.Player.PlayerEntity)
local EntityService = {}

local playerEntities: { [number]: PlayerEntity.PlayerEntity } = {}

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

		for _, player in playerEntities do
			player:update(dt)
		end
	end)

	coroutine.wrap(function()
		wait(5)
		while true do
			wait(0.1)
			for _, player in Players:GetPlayers() do
				for i = -2, 2, 1 do
					EntityService.SpawnItemEntity(player, Vector3.new(0, 100, i), "grass")
				end
				for i = -2, 2, 1 do
					EntityService.SpawnItemEntity(player, Vector3.new(i, 100, 0), "obsidian")
				end
			end
		end
	end)()
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
	local itemEntity = ItemEntity.new(player, EntityService.getPlayerEntity(player), pos, itemId, amount)
	EntityStorage.register(itemEntity.model, itemEntity)
end

function EntityService.PlayerJoined(player: Player)
	EntityService.createAndSetPlayerEntity(player)
end

function EntityService.PlayerLeaving(player: Player)
	if player.Character then
		EntityStorage.remove(player.Character:FindFirstChild("CollisionPart"))
	end
end

function EntityService.createAndSetPlayerEntity(player: Player): ()
	local inventory = DataStore.profiles[player.UserId].Data.Inventory
	local entity = PlayerEntity.new(player, Vector3.new(0, 0, 0), inventory)
	playerEntities[player.UserId] = entity
end

function EntityService.getPlayerEntity(player: Player): PlayerEntity.PlayerEntity
	return playerEntities[player.UserId]
end

return EntityService
