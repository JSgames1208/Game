local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(ReplicatedStorage.Shared.network)
local InventoryManager = {}

local Inventories = {} -- [userId] = {...}

function InventoryManager.Get(player: Player)
	return Inventories[player.UserId] or table.create(9, nil)
end

function InventoryManager.SendToClient(player: Player)
	local inventory = InventoryManager.Get(player)

	packets.InventorySync.sendTo(inventory, player)
end

function InventoryManager.PlayerJoined(player: Player)
	Inventories[player.UserId] = {
		[1] = { id = "nothing", count = 0 },
		[2] = { id = "grass", count = 32 },
		[3] = { id = "nothing", count = 0 },
		[4] = { id = "grass", count = 32 },
		[5] = { id = "nothing", count = 0 },
		[6] = { id = "grass", count = 32 },
		[7] = { id = "nothing", count = 0 },
		[8] = { id = "nothing", count = 0 },
		[9] = { id = "grass", count = 32 },
	}

	InventoryManager.SendToClient(player)
end

function InventoryManager.PlayerLeaving(player: Player)
	Inventories[player.UserId] = nil
end

return InventoryManager
