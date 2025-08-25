local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ItemStack = require(ReplicatedStorage.Shared.Item.ItemStack)
local DataStore = require(ServerScriptService.Server.Services.DataStore)
local ItemLibrary = require(ReplicatedStorage.Shared.ItemLibrary)
local packets = require(ReplicatedStorage.Shared.network)
local InventoryService = {}

local Inventories = {} -- [userId] = {...}
local SelectedSlots = {} -- [userId] = slotId

function InventoryService.Get(player: Player)
	return Inventories[player.UserId] or table.create(9, nil)
end

function InventoryService.GetSelected(player: Player)
	if InventoryService.Get(player)[SelectedSlots[player.UserId]] then
		return InventoryService.Get(player)[SelectedSlots[player.UserId]].itemInfo.id
	else
		return nil
	end
end

function InventoryService.SendToClient(player: Player)
	local inventory = InventoryService.Get(player)
	packets.InventorySync.sendTo(inventory, player)
end

function InventoryService.PlayerJoined(player: Player)
	local profile = DataStore.profiles[player.UserId]
	if not profile then
		return
	end
	local inventory = DataStore.profiles[player.UserId].Data.Inventory

	Inventories[player.UserId] = inventory
	for _, item in Inventories[player.UserId] do
		if item.count <= 0 then
			item.count = 0
			item.itemInfo.id = "nothing"
		end
	end
	--InventoryService.GiveItem(player, "pine tree sapling", 400)
	--InventoryService.GiveItem(player, "sand", 64)

	--InventoryService.RemoveItem(player, 1000, "pine tree sapling")
	--InventoryService.RemoveItem(player, 1000, "sand")

	InventoryService.SendToClient(player)
end

function InventoryService.IsAvailable(player: Player, amount: number)
	if not SelectedSlots[player.UserId] then
		return
	end
	local inventory = InventoryService.Get(player)
	local item = inventory[SelectedSlots[player.UserId]]
	if item and item.count >= amount then
		return true
	else
		return false
	end
end

function InventoryService.RemoveItem(player: Player, amount: number, itemId: string?)
	local inventory = InventoryService.Get(player)
	if itemId then
		for _, item in inventory do
			if item.itemInfo.id == itemId then
				local removeAmount = math.min(ItemLibrary.itemDefinitions[itemId].maxStack, amount)
				item.count -= removeAmount
				amount -= removeAmount
			end
		end
		DataStore.profiles[player.UserId].Data.Inventory = inventory
		InventoryService.SendToClient(player)
	else
		if not SelectedSlots[player.UserId] then
			return
		end
		inventory[SelectedSlots[player.UserId]].count -= amount
		if inventory[SelectedSlots[player.UserId]].count <= 0 then
			inventory[SelectedSlots[player.UserId]].itemInfo.id = "nothing"
			inventory[SelectedSlots[player.UserId]].count = 0
			DataStore.profiles[player.UserId].Data.Inventory = inventory
		end
		InventoryService.SendToClient(player)
	end
end

function InventoryService.insertStack(player: Player, slot: number, stack: ItemStack.ItemStack): boolean
	if stack:isEmpty() then
		return false
	else
		local i: number
		repeat
			i = stack:getCount()
			if slot == -1 then
			end
		until 1 == 1
	end

	return true
end

function InventoryService.addStack(player: Player, stack: ItemStack.ItemStack, slot: number?)
	local i = stack:getCount()
	local itemStack = InventoryService.getStack(player, 1)
end

function InventoryService.getStack(player: Player, slot: number) end

function InventoryService.GiveItem(player: Player, itemId: string, amount: number)
	local inventory = InventoryService.Get(player)
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

	InventoryService.SendToClient(player)
end

function InventoryService.SwapSlots(player: Player, from: number, to: number)
	local inventory = InventoryService.Get(player)
	if inventory[from].itemInfo.id == inventory[to].itemInfo.id then
		local toAdd = math.min(
			ItemLibrary.itemDefinitions[inventory[from].itemInfo.id].maxStack - inventory[to].count,
			inventory[from].count
		)
		inventory[to].count = inventory[to].count + toAdd
		inventory[from].count = inventory[from].count - toAdd
		if inventory[from].count <= 0 then
			inventory[from].itemInfo.id = "nothing"
			inventory[from].count = 0
		end
	else
		local holder = table.clone(inventory[to])
		inventory[to] = inventory[from]
		inventory[from] = holder
	end

	InventoryService.SendToClient(player)
end

function InventoryService.PlayerLeaving(player: Player)
	Inventories[player.UserId] = nil
end

packets.SlotPressed.listen(function(data, player: Player)
	SelectedSlots[player.UserId] = data.slotIndex > 0 and data.slotIndex or nil
end)

packets.SwapSlots.listen(function(data: { from: number, to: number }, player: Player)
	InventoryService.SwapSlots(player, data.from, data.to)
end)

return InventoryService
