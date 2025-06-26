local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)
local InventoryManager = {}

local Inventories = {} -- [userId] = {...}
local SelectedSlots = {} -- [userId] = slotId

function InventoryManager.Get(player: Player)
	return Inventories[player.UserId] or table.create(9, nil)
end

function InventoryManager.SendToClient(player: Player)
	local inventory = InventoryManager.Get(player)

	packets.InventorySync.sendTo(inventory, player)
end

function InventoryManager.PlayerJoined(player: Player)
	Inventories[player.UserId] = {
		[1] = { id = "stone", count = 2 },
		[2] = { id = "grass", count = 16 },
		[3] = { id = "stone", count = 24 },
		[4] = { id = "sand", count = 32 },
		[5] = { id = "log", count = 64 },
		[6] = { id = "dirt", count = 64 },
		[7] = { id = "stone", count = 4 },
		[8] = { id = "nothing", count = 0 },
		[9] = { id = "grass", count = 32 },
	}

	InventoryManager.SendToClient(player)
end

function InventoryManager.IsAvailable(player: Player, amount: number)
	if not SelectedSlots[player.UserId] then
		return
	end
	local inventory = InventoryManager.Get(player)
	local item = inventory[SelectedSlots[player.UserId]]
	if item and item.count >= amount then
		return true
	else
		return false
	end
end

function InventoryManager.RemoveItem(player: Player, amount: number)
	if not SelectedSlots[player.UserId] then
		return
	end
	local inventory = InventoryManager.Get(player)
	inventory[SelectedSlots[player.UserId]].count -= amount
	if inventory[SelectedSlots[player.UserId]].count <= 0 then
		inventory[SelectedSlots[player.UserId]].id = "nothing"
		inventory[SelectedSlots[player.UserId]].count = 0
	end
	InventoryManager.SendToClient(player)
end

function InventoryManager.PlayerLeaving(player: Player)
	Inventories[player.UserId] = nil
end

packets.SlotPressed.listen(function(data, player: Player)
	SelectedSlots[player.UserId] = data.slotIndex > 0 and data.slotIndex or nil
end)

return InventoryManager
