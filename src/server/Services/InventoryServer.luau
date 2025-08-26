local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local EntityService = require(script.Parent.EntityService)
local PlayerEntity = require(ServerScriptService.Server.Entity.Player.PlayerEntity)
local PlayerInventory = require(ServerScriptService.Server.Entity.Player.PlayerInventory)
local packets = require(ReplicatedStorage.Shared.network)
local InventoryService = {}

local function getPlayerEntity(player): PlayerEntity.PlayerEntity
	return EntityService.getPlayerEntity(player)
end

local function getPlayerInventory(player): PlayerInventory.PlayerInventory
	return getPlayerEntity(player):getInventory()
end

packets.SlotPressed.listen(function(data, player: Player)
	getPlayerInventory(player):setSelectedSlot(data.slotIndex)
end)

packets.SwapSlots.listen(function(data: { from: number, to: number }, player: Player)
	getPlayerInventory(player):swapSlots(data.from, data.to)
end)

return InventoryService
