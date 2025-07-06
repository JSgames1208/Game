local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStore = require(script.Parent.DataStore)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local packets = require(ReplicatedStorage.Shared.network)
local InventoryManager = {}

local Inventories = {} -- [userId] = {...}
local SelectedSlots = {} -- [userId] = slotId

function InventoryManager.Get(player: Player)
	return Inventories[player.UserId] or table.create(9, nil)
end

function InventoryManager.GetSelected(player: Player)
	return InventoryManager.Get(player)[SelectedSlots[player.UserId]].itemInfo.id
end

function InventoryManager.SendToClient(player: Player)
	local inventory = InventoryManager.Get(player)
	print(inventory)
	packets.InventorySync.sendTo(inventory, player)
end

function InventoryManager.PlayerJoined(player: Player)
	local inventory = DataStore.profiles[player.UserId].Data.Inventory

	Inventories[player.UserId] = inventory
	for _, item in Inventories[player.UserId] do
		if item.count <= 0 then
			item.count = 0
			item.itemInfo.id = "nothing"
		end
	end
	--InventoryManager.GiveItem(player, "pine tree sapling", 16)

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
		inventory[SelectedSlots[player.UserId]].itemInfo.id = "nothing"
		inventory[SelectedSlots[player.UserId]].count = 0
		DataStore.profiles[player.UserId].Data.Inventory = inventory
	end
	InventoryManager.SendToClient(player)
end

function InventoryManager.GiveItem(player: Player, itemId: string, amount: number)
	print(itemId, amount)
	local inventory = InventoryManager.Get(player)
	local maxStack = ItemLibrary.itemDefinitions[itemId].maxStack
	for _, item in ipairs(inventory) do
		if item.itemInfo.id == itemId and item.count < maxStack then
			local spaceLeft = maxStack - item.count
			local toAdd = math.min(amount, spaceLeft)
			item.count += toAdd
			amount -= toAdd
			if amount <= 0 then
				break
			end
		end
	end
	if amount > 0 then
		for _, item in ipairs(inventory) do
			if item.itemInfo.id == "nothing" then
				local toAdd = math.min(amount, maxStack)
				item.itemInfo.id = itemId
				item.count = toAdd
				amount -= toAdd
				if amount <= 0 then
					break
				end
			end
		end
	end

	DataStore.profiles[player.UserId].Data.Inventory = inventory

	InventoryManager.SendToClient(player)
end

function InventoryManager.PlayerLeaving(player: Player)
	Inventories[player.UserId] = nil
end

packets.SlotPressed.listen(function(data, player: Player)
	SelectedSlots[player.UserId] = data.slotIndex > 0 and data.slotIndex or nil
end)

return InventoryManager
